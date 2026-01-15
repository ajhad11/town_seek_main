// IMPLEMENTATION GUIDE FOR MAIN ADMIN PANEL
// Add this to your main.dart to enable the admin panel

/*

=== STEP 1: Update main.dart ===

Add route to main admin panel:

```dart
import 'package:town_seek/screens/admin/main_admin/main_admin_auth_guard.dart';

MaterialApp(
  routes: {
    '/': (context) => const HomePage(),
    '/admin-panel': (context) => const MainAdminAuthGuard(),  // ADD THIS
    // ... other routes
  },
)
```

=== STEP 2: Update Supabase RLS Policies ===

Create policy for super admin:

```sql
-- Enable RLS on all tables
ALTER TABLE users ENABLE ROW LEVEL SECURITY;
ALTER TABLE shops ENABLE ROW LEVEL SECURITY;
ALTER TABLE products ENABLE ROW LEVEL SECURITY;
ALTER TABLE promotions ENABLE ROW LEVEL SECURITY;
ALTER TABLE reviews ENABLE ROW LEVEL SECURITY;

-- Super Admin Policy
CREATE POLICY "Super Admin Only"
ON users
FOR ALL
USING (auth.email() = 'ajhadk453@gmail.com');

CREATE POLICY "Super Admin Only"
ON shops
FOR ALL
USING (auth.email() = 'ajhadk453@gmail.com');

-- Repeat for all other tables...
```

=== STEP 3: Environment Variables ===

Create .env file:

```
SUPABASE_URL=your_supabase_url
SUPABASE_ANON_KEY=your_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_service_role_key
SUPER_ADMIN_EMAIL=ajhadk453@gmail.com
```

=== STEP 4: Update pubspec.yaml ===

Ensure these dependencies are present:

```yaml
dependencies:
  flutter:
    sdk: flutter
  supabase_flutter: ^1.0.0
  uuid: ^3.0.0
  provider: ^6.0.0
  shared_preferences: ^2.0.0
  
dev_dependencies:
  flutter_test:
    sdk: flutter
  flutter_lints: ^2.0.0
```

=== STEP 5: Authentication Setup ===

In supabase_service.dart, ensure admin check:

```dart
static Future<bool> verifyAdminAccess() async {
  final user = currentUser;
  const String SUPER_ADMIN = 'ajhadk453@gmail.com';
  
  if (user?.email != SUPER_ADMIN) {
    await signOut();
    return false;
  }
  return true;
}
```

=== STEP 6: Navigation Integration ===

Add admin button to your main app (optional):

```dart
// In your profile/settings menu
if (userEmail == 'ajhadk453@gmail.com') {
  ListTile(
    title: const Text('Admin Panel'),
    leading: const Icon(Icons.shield_admin_rounded),
    onTap: () => Navigator.pushNamed(context, '/admin-panel'),
  )
}
```

=== STEP 7: Testing ===

Run the app and test:

```bash
flutter run

# Test admin access:
# 1. Login with: ajhadk453@gmail.com
# 2. Navigate to: /admin-panel
# 3. Verify dashboard loads
# 4. Test each section

# Test unauthorized access:
# 1. Login with any other email
# 2. Try to navigate to: /admin-panel
# 3. Should show "Access Denied"
```

=== STEP 8: Database Schema (SQL) ===

If creating from scratch:

```sql
-- Users
CREATE TABLE users (
  id UUID PRIMARY KEY,
  name TEXT NOT NULL,
  email TEXT UNIQUE NOT NULL,
  is_active BOOLEAN DEFAULT TRUE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Shops
CREATE TABLE shops (
  id UUID PRIMARY KEY,
  owner_id UUID REFERENCES users(id),
  name TEXT NOT NULL,
  location TEXT,
  rating FLOAT DEFAULT 0,
  is_verified BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);

-- Products
CREATE TABLE products (
  id UUID PRIMARY KEY,
  shop_id UUID REFERENCES shops(id),
  name TEXT NOT NULL,
  price DECIMAL(10, 2),
  stock_quantity INTEGER DEFAULT 0,
  is_available BOOLEAN DEFAULT TRUE
);

-- Promotions
CREATE TABLE promotions (
  id UUID PRIMARY KEY,
  shop_id UUID REFERENCES shops(id),
  start_date DATE,
  end_date DATE,
  is_active BOOLEAN DEFAULT FALSE,
  cost_per_month DECIMAL(10, 2)
);

-- Reviews
CREATE TABLE reviews (
  id UUID PRIMARY KEY,
  user_id UUID REFERENCES users(id),
  shop_id UUID REFERENCES shops(id),
  rating INTEGER,
  text TEXT,
  is_flagged BOOLEAN DEFAULT FALSE,
  created_at TIMESTAMP DEFAULT NOW()
);
```

=== STEP 9: Logging (Optional but Recommended) ===

Create admin_logs table:

```sql
CREATE TABLE admin_logs (
  id UUID PRIMARY KEY,
  admin_email TEXT NOT NULL,
  action TEXT NOT NULL,
  target_table TEXT,
  target_id UUID,
  changes JSONB,
  timestamp TIMESTAMP DEFAULT NOW()
);

-- Function to log admin actions
CREATE OR REPLACE FUNCTION log_admin_action(
  admin_email TEXT,
  action TEXT,
  target_table TEXT,
  target_id UUID,
  changes JSONB
) RETURNS void AS $$
BEGIN
  INSERT INTO admin_logs (admin_email, action, target_table, target_id, changes, timestamp)
  VALUES (admin_email, action, target_table, target_id, changes, NOW());
END;
$$ LANGUAGE plpgsql;
```

=== STEP 10: Connect to Supabase Service ===

Update supabase_service.dart to integrate admin methods:

```dart
// Add admin-specific methods
static Future<List<dynamic>> getAdminStats() async {
  final db = await _db;
  final users = await db.query('users');
  final shops = await db.query('shops');
  final reviews = await db.query('reviews');
  
  return [users.length, shops.length, reviews.length];
}

static Future<void> logAdminAction(
  String action,
  String targetTable,
  String targetId,
  Map<String, dynamic> changes,
) async {
  final db = await _db;
  
  await db.insert('admin_logs', {
    'admin_email': currentUser?.email,
    'action': action,
    'target_table': targetTable,
    'target_id': targetId,
    'changes': jsonEncode(changes),
    'timestamp': DateTime.now().toIso8601String(),
  });
}
```

=== DEPLOYMENT CHECKLIST ===

Before going live:

- [ ] All RLS policies configured
- [ ] Email verification enabled
- [ ] Admin account created (ajhadk453@gmail.com)
- [ ] Database backups scheduled
- [ ] Logging system active
- [ ] All screens tested
- [ ] Navigation working
- [ ] Supabase connection verified
- [ ] Environment variables set
- [ ] Error handling tested
- [ ] Performance tested with real data
- [ ] Security audit completed

=== MONITORING ===

After deployment, monitor:

1. Admin access logs
2. Database query performance
3. Failed actions/errors
4. User activity suspicious patterns
5. System resource usage

=== EMERGENCY PROCEDURES ===

If unauthorized access detected:
1. Immediately change admin password
2. Review admin_logs table
3. Check for suspicious activities
4. Audit all data changes
5. Restore from backup if needed

*/
