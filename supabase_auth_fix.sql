-- SQL Schema and Triggers to fix Authentication Issues

-- 1. Create a function to handle new user headers
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email, full_name, role)
  VALUES (
    new.id, 
    new.email, 
    new.raw_user_meta_data->>'full_name',
    COALESCE(new.raw_user_meta_data->>'role', 'user')
  );
  RETURN new;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 2. Drop the trigger if it exists to avoid errors on multiple runs
DROP TRIGGER IF EXISTS on_auth_user_created ON auth.users;

-- 3. Create the trigger to call the function on INSERT in auth.users
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE PROCEDURE public.handle_new_user();

-- 4. Ensure RLS Policies allow necessary access (Refined)

-- Enable RLS (Should already be enabled)
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;

-- Drop existing policies to avoid conflicts
DROP POLICY IF EXISTS "Users can view their own profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can update their own profiles" ON public.user_profiles;
DROP POLICY IF EXISTS "Users can insert their own profile" ON public.user_profiles;

-- Re-create policies
CREATE POLICY "Users can view their own profiles" 
ON public.user_profiles FOR SELECT 
USING (auth.uid() = id);

CREATE POLICY "Users can update their own profiles" 
ON public.user_profiles FOR UPDATE 
USING (auth.uid() = id);

-- (Optional) If you ever need manual insert from client side
CREATE POLICY "Users can insert their own profile" 
ON public.user_profiles FOR INSERT 
WITH CHECK (auth.uid() = id);

-- 5. Fix Businesses and other tables Policies for public read
DROP POLICY IF EXISTS "Public read for businesses" ON public.businesses;
CREATE POLICY "Public read for businesses" ON public.businesses FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read for products" ON public.products;
CREATE POLICY "Public read for products" ON public.products FOR SELECT USING (true);

DROP POLICY IF EXISTS "Public read for services" ON public.services;
CREATE POLICY "Public read for services" ON public.services FOR SELECT USING (true);
