-- SQL Setup for Admin System (Supabase)

-- 1. Create the Admins Table
CREATE TABLE IF NOT EXISTS public.admins (
    id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
    email TEXT UNIQUE NOT NULL,
    role TEXT NOT NULL DEFAULT 'business_admin' CHECK (role IN ('super_admin', 'business_admin')),
    business_id UUID REFERENCES public.businesses(id) ON DELETE SET NULL,
    is_approved BOOLEAN DEFAULT false,
    created_at TIMESTAMPTZ DEFAULT NOW(),
    updated_at TIMESTAMPTZ DEFAULT NOW()
);

-- 2. Enable RLS on admins table
ALTER TABLE public.admins ENABLE ROW LEVEL SECURITY;

-- 3. RLS Policies for Admins Table
-- Super Admins can do everything
CREATE POLICY "Super admins can manage all admin records"
ON public.admins
FOR ALL
USING (
    EXISTS (
        SELECT 1 FROM public.admins 
        WHERE id = auth.uid() AND role = 'super_admin'
    )
)
WITH CHECK (
    EXISTS (
        SELECT 1 FROM public.admins 
        WHERE id = auth.uid() AND role = 'super_admin'
    )
);

-- Business Admins can view their own record
CREATE POLICY "Admins can view their own admin record"
ON public.admins
FOR SELECT
USING (auth.uid() = id);

-- 4. Update Business RLS for Admins
DROP POLICY IF EXISTS "Super admins can manage all businesses" ON public.businesses;
CREATE POLICY "Super admins can manage all businesses"
ON public.businesses
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND role = 'super_admin')
);

DROP POLICY IF EXISTS "Business admins can manage their own business" ON public.businesses;
CREATE POLICY "Business admins can manage their own business"
ON public.businesses
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND business_id = public.businesses.id)
);

-- 5. Update Products RLS for Admins
DROP POLICY IF EXISTS "Super admins can manage all products" ON public.products;
CREATE POLICY "Super admins can manage all products"
ON public.products
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND role = 'super_admin')
);

DROP POLICY IF EXISTS "Business admins can manage their products" ON public.products;
CREATE POLICY "Business admins can manage their products"
ON public.products
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND business_id = public.products.business_id)
);

-- 6. Update Services RLS for Admins
DROP POLICY IF EXISTS "Super admins can manage all services" ON public.services;
CREATE POLICY "Super admins can manage all services"
ON public.services
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND role = 'super_admin')
);

DROP POLICY IF EXISTS "Business admins can manage their services" ON public.services;
CREATE POLICY "Business admins can manage their services"
ON public.services
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND business_id = public.services.business_id)
);

-- 7. Update Bookings RLS for Admins
DROP POLICY IF EXISTS "Super admins can manage all bookings" ON public.bookings;
CREATE POLICY "Super admins can manage all bookings"
ON public.bookings
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND role = 'super_admin')
);

DROP POLICY IF EXISTS "Business admins can manage their bookings" ON public.bookings;
CREATE POLICY "Business admins can manage their bookings"
ON public.bookings
FOR ALL
USING (
    EXISTS (SELECT 1 FROM public.admins WHERE id = auth.uid() AND business_id = public.bookings.business_id)
);

-- 8. Functions
CREATE OR REPLACE FUNCTION public.get_current_user_role()
RETURNS TEXT AS $$
BEGIN
    RETURN (SELECT role FROM public.admins WHERE id = auth.uid());
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- 9. Trigger for updated_at
CREATE OR REPLACE FUNCTION public.handle_updated_at()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ LANGUAGE plpgsql;

CREATE TRIGGER set_admins_updated_at
BEFORE UPDATE ON public.admins
FOR EACH ROW
EXECUTE FUNCTION public.handle_updated_at();

-- 10. Initial Seed for Admin Access
-- IMPORTANT: You must first create these users in Supabase Auth (Authentication -> Users)
-- Once the users are created, you can run these queries with their actual IDs.

-- Example seeding (replace UUIDs with real ones from auth.users):

-- SUPER ADMIN
-- INSERT INTO public.admins (id, email, role, is_approved) 
-- SELECT id, 'ajhadk8@gmail.com', 'super_admin', true 
-- FROM auth.users WHERE email = 'ajhadk8@gmail.com'
-- ON CONFLICT (id) DO NOTHING;

-- BUSINESS ADMIN Example
-- INSERT INTO public.admins (id, email, role, business_id, is_approved) 
-- SELECT id, 'ajhadk453@gmail.com', 'business_admin', 'BUSINESS_UUID_HERE', true 
-- FROM auth.users WHERE email = 'ajhadk453@gmail.com'
-- ON CONFLICT (id) DO NOTHING;

-- Note: RLS will ensure that only Super Admin can assign these roles later through the UI.
