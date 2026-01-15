# 🔐 Town Seek Main Admin Panel

## Overview

A comprehensive **Flutter Admin Dashboard** for managing the entire Town Seek ecosystem. Accessible **ONLY** to the Super Admin email: `ajhadk453@gmail.com`

---

## 🏗️ Architecture

### File Structure

```
lib/screens/admin/main_admin/
├── main_admin_auth_guard.dart      # Authentication gatekeeper
├── main_admin_panel.dart           # Main navigation hub
└── screens/
    ├── admin_dashboard_screen.dart          # Dashboard with stats
    ├── user_management_screen.dart          # User CRUD operations
    ├── shop_management_screen.dart          # Shop approval & moderation
    ├── promotion_management_screen.dart     # Paid promotions
    ├── review_moderation_screen.dart        # Review management
    ├── analytics_screen.dart                # Platform insights
    └── system_settings_screen.dart          # Configuration
```

---

## 🔐 Security Features

### Authentication Guard

```dart
// Only allows ajhadk453@gmail.com
const String SUPER_ADMIN_EMAIL = 'ajhadk453@gmail.com';

// Checks on app start
if (user?.email != SUPER_ADMIN_EMAIL) {
  await SupabaseService.signOut();
}
```

### Access Control

- ✅ Email-based authentication
- ✅ Automatic logout for unauthorized users
- ✅ Session persistence check
- ✅ Blocked screen for unauthorized access

---

## 📊 Dashboard Overview

### Key Metrics (Real-time Stats)

| Metric | Description |
|--------|-------------|
| **Total Users** | Active platform users |
| **Total Shops** | Registered businesses |
| **Total Hospitals** | Healthcare providers |
| **Active Promotions** | Ongoing paid listings |
| **Today's Searches** | Platform search volume |
| **System Health** | Uptime & performance |

---

## 👥 User Management

### Features

✅ **Search & Filter**
- By name, email, or ID
- Export user data

✅ **User Actions**
- View activity logs
- Activate/Deactivate accounts
- Permanent deletion with confirmation

✅ **Display Columns**
- Name
- Email
- Account Status
- Join Date
- Action Menu

---

## 🏪 Shop Management

### Features

✅ **Shop Approval Workflow**
- Review pending shop registrations
- Approve or reject applications
- View shop details & analytics

✅ **Shop Moderation**
- Suspend misbehaving shops
- Edit shop information
- View product/service inventory
- Check customer ratings

✅ **Filter Options**
- All shops
- Pending approval
- Verified
- Suspended

---

## 🎯 Promotion Management

### Features

✅ **Paid Promotions**
- Approve promotion requests
- Set featured shop rankings
- Monitor promotion revenue
- View click metrics

✅ **Homepage Control**
- Manage featured listings
- Control shop ranking/visibility
- Revenue per promotion tier

---

## ⭐ Review Moderation

### Features

✅ **Review Approval**
- Pending reviews queue
- Approve legitimate reviews
- Flag suspicious content

✅ **Community Protection**
- Delete fake reviews
- Detect spam patterns
- Ban repeat offenders
- View review history

✅ **Filter Status**
- Pending approval
- Approved
- Flagged/Suspicious

---

## 📈 Analytics

### Insights Provided

✅ **Search Analytics**
- Most searched items
- High-demand locations
- Search trends by category

✅ **Conversion Metrics**
- Click-to-visit ratio
- Conversion rates
- Abandoned searches

✅ **Performance Charts**
- Weekly/Monthly trends
- Growth indicators
- System health metrics

---

## ⚙️ System Settings

### Configuration Options

#### General Settings
- 🔧 Maintenance Mode (take platform offline)
- 📊 Analytics toggle
- 🔔 Notification settings

#### Category Management
- ➕ Add new categories
- ✏️ Edit existing categories
- 🗑️ Delete categories
- View active categories count

#### API & Integration
- Supabase credentials
- Firebase keys
- API key management
- Secret key rotation

#### Dangerous Zone
- ⚠️ Clear all data
- Reset database
- Requires confirmation

---

## 🔄 Database Integration

### Supabase Tables

#### users
```sql
id (UUID) | name | email | is_active | created_at
```

#### shops
```sql
id | owner_id | name | location | rating | is_verified | created_at
```

#### products
```sql
id | shop_id | name | price | stock_quantity | is_available
```

#### promotions
```sql
id | shop_id | start_date | end_date | is_active | cost_per_month
```

#### reviews
```sql
id | user_id | shop_id | rating | text | is_flagged | created_at
```

---

## 🚀 Usage Guide

### Accessing the Admin Panel

1. **Login** with authorized email
2. **Authentication guard** verifies access
3. **Dashboard** loads with full controls
4. **Navigate** via sidebar menu

### Common Admin Tasks

#### Approve a Shop
1. Go to **Shops** tab
2. Find pending shop
3. Click **Approve** button
4. Confirm action

#### Moderate a Review
1. Go to **Reviews** tab
2. Review flagged content
3. Choose: Approve / Flag / Delete
4. System logs action

#### Create Promotion
1. Go to **Promotions** tab
2. Click **New Promotion**
3. Select shop & duration
4. Set pricing tier
5. Publish

---

## 📝 Admin Action Logging

All admin actions are logged for security:

✅ **Logged Actions**
- User deletions
- Shop suspensions
- Review deletions
- Promotion approvals
- Settings changes
- Data exports

---

## 🎨 UI Components

### Design System

- **Color Scheme**: Deep Purple theme
- **Icons**: Material Design 3
- **Responsive**: Desktop-first
- **Sidebar Navigation**: Left panel
- **Status Badges**: Color-coded

### Key UI Elements

```dart
// Navigation Item
AdminNavItem(
  icon: Icons.dashboard_rounded,
  label: 'Dashboard',
  badge: '3',  // Optional notification badge
)

// Stat Card
_buildStatCard(
  title: 'Total Users',
  value: '12,456',
  icon: Icons.people_rounded,
  color: Colors.blue,
)

// Setting Toggle
_buildSwitchSetting(
  title: 'Maintenance Mode',
  subtitle: 'Put platform under maintenance',
  value: _maintenanceMode,
  onChanged: (value) { /* ... */ },
)
```

---

## 🔒 Security Best Practices

### Implemented

✅ Email-based access control
✅ Automatic session validation
✅ Confirmation dialogs for destructive actions
✅ Action logging
✅ Row-level security (RLS) in database
✅ No hardcoded secrets
✅ State management for data

### Recommended

🔐 Enable 2FA for super admin account
🔐 Regular backups of database
🔐 Monitor access logs
🔐 Rotate API keys quarterly

---

## 🐛 Troubleshooting

### "Access Denied" Message
- Verify login email is `ajhadk453@gmail.com`
- Clear app cache and login again
- Check Supabase auth status

### Stats Not Loading
- Verify Supabase connection
- Check network connectivity
- Review database permissions

### Actions Not Saving
- Ensure RLS policies allow super admin
- Check write permissions in Supabase
- Verify data format before saving

---

## 📋 Checklist for Deployment

- [ ] Configure Supabase RLS policies
- [ ] Set up email verification
- [ ] Enable backup schedules
- [ ] Configure analytics tracking
- [ ] Set up admin email notifications
- [ ] Test authorization flow
- [ ] Document custom categories
- [ ] Set maintenance mode schedule

---

## 🚀 Future Enhancements

- [ ] Advanced chart visualizations
- [ ] Batch operations (bulk delete)
- [ ] Admin role hierarchy
- [ ] Custom reports builder
- [ ] Email notifications
- [ ] Audit trail dashboard
- [ ] API rate limiting controls
- [ ] Advanced search filters

---

## 📞 Support

For issues or questions:
- Email: `ajhadk453@gmail.com`
- Check application logs
- Review database schema
- Verify API connections

---

**Last Updated:** January 2026
**Version:** 1.0.0
**Status:** Production Ready ✅
