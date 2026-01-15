# Quick Start Guide - Business Account System

## 🚀 Getting Started

### Prerequisites
- **Flutter SDK**: Installed and added to PATH.
- **Java Development Kit (JDK) 24**: Required for the build configuration.
  - Ensure it is installed at `C:\Program Files\Java\jdk-24` OR update the path in `android/gradle.properties`.
- **Android Studio**: With Android SDK and Command-line Tools installed.
- **Supabase Account**: Configured with valid URL and Anon Key in `lib/main.dart` (or `lib/services/supabase_constants.dart`).

### ⚙️ Critical Configuration
**Before running the app**, ensure your Java path is correctly set:

1. Open `android/gradle.properties`.
2. Locate the line:
   ```properties
   org.gradle.java.home=C:\\Program Files\\Java\\jdk-24
   ```
3. If your JDK 24 is installed elsewhere, update this path to match your installation.

### Running the App

```bash
# Navigate to project directory
cd h:/ajhad/aas/google/town_seek

# Get dependencies
flutter pub get

# Run the app
flutter run
```

## 📱 Testing the Business Account System

### Step 1: Access Business Login
1. Launch the app
2. Navigate to **Profile** (bottom navigation, rightmost icon)
3. Scroll down and tap **"Business Account"**
4. You'll see the Business Login screen

### Step 2: Login as Business Owner
```
Email: your-business-email@example.com
Password: your-password
```

**Note**: The account must:
- Be registered in Supabase
- Have a business associated with it in the `businesses` table
- The `businesses.owner_id` must match the user's ID

### Step 3: Explore the Dashboard
After successful login, you'll see:
- **Business Header**: Your business logo, name, category, and rating
- **Quick Actions**: 4 cards for Products, Services, Bookings, and Settings
- **Statistics**: Total bookings and pending count
- **Recent Bookings**: Last 5 bookings

### Step 4: Manage Products

#### Add a Product:
1. Tap **"Products"** from quick actions
2. Tap the **floating "Add Product"** button
3. Fill in:
   - Product Name (required)
   - Description (optional)
   - Price (required)
   - Image URL (optional)
   - Toggle availability
4. Tap **"Add"**

#### Edit a Product:
1. Find the product card
2. Tap the **blue edit icon**
3. Modify fields
4. Tap **"Update"**

#### Delete a Product:
1. Find the product card
2. Tap the **red delete icon**
3. Confirm deletion

### Step 5: Manage Services

#### Add a Service:
1. Tap **"Services"** from quick actions
2. Tap the **floating "Add Service"** button
3. Fill in:
   - Service Name (required)
   - Description (optional)
   - Price (required)
   - Duration in minutes (required)
   - Toggle availability
4. Tap **"Add"**

#### Edit/Delete Service:
Same process as products

### Step 6: Manage Bookings

1. Tap **"Bookings"** from quick actions
2. Use tabs to filter:
   - **All**: All bookings
   - **Pending**: Awaiting confirmation
   - **Confirmed**: Accepted bookings
   - **Completed**: Finished bookings
3. Tap a booking to expand details
4. Update status by tapping status buttons:
   - Orange: Pending
   - Green: Confirmed
   - Blue: Completed
   - Red: Cancelled

### Step 7: Update Business Settings

1. Tap **"Settings"** from quick actions
2. Edit:
   - Business Name
   - Description
   - Category
   - Address
   - Image URL
3. Toggle **"Business is Open"** switch
4. Tap **"Save Settings"**

## 🎯 Common Tasks

### Task: Add 5 Products Quickly
```
1. Dashboard → Products → Add Product
2. Fill form → Add
3. Repeat 4 more times
4. Pull down to refresh list
```

### Task: Update All Pending Bookings
```
1. Dashboard → Bookings → Pending tab
2. Tap first booking → Expand
3. Tap "CONFIRMED" button
4. Repeat for remaining bookings
```

### Task: Close Business Temporarily
```
1. Dashboard → Settings
2. Toggle "Business is Open" to OFF
3. Tap "Save Settings"
```

## 🔍 Troubleshooting

### Issue: "No business found for this account"
**Solution**: 
- Ensure the user has a business in the `businesses` table
- Check that `businesses.owner_id` matches the user's ID
- Verify the user is logged in

### Issue: Products/Services not showing
**Solution**:
- Check database connection
- Verify `business_id` matches in products/services tables
- Pull down to refresh

### Issue: Can't update booking status
**Solution**:
- Check internet connection
- Verify booking belongs to your business
- Check Supabase permissions

## 📊 Database Setup

### Required Tables:

#### businesses
```sql
CREATE TABLE businesses (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  owner_id UUID REFERENCES auth.users(id),
  name TEXT NOT NULL,
  description TEXT,
  category TEXT,
  image_url TEXT,
  address TEXT,
  latitude DOUBLE PRECISION,
  longitude DOUBLE PRECISION,
  rating DOUBLE PRECISION DEFAULT 0,
  tags TEXT[],
  is_open BOOLEAN DEFAULT true,
  facilities JSONB,
  metadata JSONB,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### products
```sql
CREATE TABLE products (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DOUBLE PRECISION NOT NULL,
  image_url TEXT,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### services
```sql
CREATE TABLE services (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  business_id UUID REFERENCES businesses(id) ON DELETE CASCADE,
  name TEXT NOT NULL,
  description TEXT,
  price DOUBLE PRECISION NOT NULL,
  duration_minutes INTEGER NOT NULL,
  is_available BOOLEAN DEFAULT true,
  created_at TIMESTAMP DEFAULT NOW()
);
```

#### bookings
```sql
CREATE TABLE bookings (
  id UUID PRIMARY KEY DEFAULT uuid_generate_v4(),
  user_id UUID REFERENCES auth.users(id),
  business_id UUID REFERENCES businesses(id),
  service_type TEXT NOT NULL,
  booking_date TIMESTAMP NOT NULL,
  status TEXT DEFAULT 'pending',
  notes TEXT,
  created_at TIMESTAMP DEFAULT NOW()
);
```

## 🎨 UI Features

### Color Meanings:
- **Purple**: Business/Admin features
- **Blue**: Products
- **Green**: Services, Confirmed status
- **Orange**: Bookings, Pending status
- **Red**: Cancelled, Delete actions

### Interactive Elements:
- **Pull to Refresh**: Works on all list screens
- **Tap to Expand**: Booking cards expand for details
- **Floating Action Button**: Add new items
- **Icon Buttons**: Quick edit/delete actions
- **Status Chips**: Visual status indicators

## 📝 Tips & Best Practices

### For Business Owners:
1. **Keep business open**: Toggle status in settings
2. **Update regularly**: Refresh products/services availability
3. **Respond quickly**: Check bookings daily
4. **Complete info**: Add descriptions and images
5. **Monitor stats**: Check dashboard statistics

### For Developers:
1. **Test with real data**: Create sample businesses
2. **Check permissions**: Verify Supabase RLS policies
3. **Handle errors**: All screens have error states
4. **Optimize images**: Use compressed image URLs
5. **Monitor performance**: Check loading times

## 🔐 Security Notes

- All operations require authentication
- Business owners can only manage their own business
- Supabase RLS policies should be configured
- Client-side validation is implemented
- Destructive actions require confirmation

## 📞 Support

For issues or questions:
- Email: support@townseek.com
- Check: `BUSINESS_ACCOUNT_SYSTEM.md` for detailed documentation
- Review: `NAVIGATION_FLOW.md` for navigation structure

## ✅ Checklist for First Use

- [ ] Supabase configured
- [ ] Database tables created
- [ ] Business account created
- [ ] Business linked to user account
- [ ] App running successfully
- [ ] Can login to business account
- [ ] Dashboard loads correctly
- [ ] Can add products
- [ ] Can add services
- [ ] Can view bookings
- [ ] Can update settings

---

**Ready to go!** 🎉 Your business account system is fully functional and ready for use.
