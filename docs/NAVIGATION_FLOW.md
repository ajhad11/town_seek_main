# Business Account System - Navigation Flow

## App Navigation Structure

```
┌─────────────────────────────────────────────────────────────┐
│                         MAIN APP                             │
│                    (Main Screen)                             │
│                                                              │
│  ┌──────────┬──────────┬──────────┬──────────┬──────────┐  │
│  │  Home    │ Explore  │ Wishlist │ Services │ Profile  │  │
│  └──────────┴──────────┴──────────┴──────────┴────┬─────┘  │
│                                                     │         │
└─────────────────────────────────────────────────────┼────────┘
                                                      │
                                                      ▼
                                        ┌─────────────────────┐
                                        │   Profile Page      │
                                        │   (Settings)        │
                                        └─────────┬───────────┘
                                                  │
                        ┌─────────────────────────┼─────────────────────────┐
                        │                         │                         │
                        ▼                         ▼                         ▼
              ┌──────────────────┐    ┌──────────────────┐    ┌──────────────────┐
              │ Edit Profile     │    │ Business Account │    │    About Us      │
              └──────────────────┘    └────────┬─────────┘    └──────────────────┘
                                               │
                                               ▼
                                    ┌──────────────────────┐
                                    │ Business Login       │
                                    │ Screen               │
                                    └──────────┬───────────┘
                                               │
                                               ▼
                                    ┌──────────────────────┐
                                    │ Business Admin       │
                                    │ Dashboard            │
                                    └──────────┬───────────┘
                                               │
                ┌──────────────────────────────┼──────────────────────────────┐
                │                              │                              │
                ▼                              ▼                              ▼
    ┌──────────────────┐          ┌──────────────────┐          ┌──────────────────┐
    │   Products       │          │   Services       │          │   Bookings       │
    │   Management     │          │   Management     │          │   Management     │
    │                  │          │                  │          │                  │
    │  • Add Product   │          │  • Add Service   │          │  • View All      │
    │  • Edit Product  │          │  • Edit Service  │          │  • Pending       │
    │  • Delete Product│          │  • Delete Service│          │  • Confirmed     │
    └──────────────────┘          └──────────────────┘          │  • Completed     │
                                                                 │  • Update Status │
                                                                 └──────────────────┘
                │
                ▼
    ┌──────────────────┐
    │   Settings       │
    │                  │
    │  • Edit Business │
    │  • Toggle Status │
    │  • View Info     │
    └──────────────────┘
```

## User Roles & Access

```
┌─────────────────────────────────────────────────────────────┐
│                      USER ROLES                              │
└─────────────────────────────────────────────────────────────┘

┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│   Regular User   │     │  Business Admin  │     │  Super Admin     │
│   (AppRole.user) │     │ (AppRole.business│     │ (AppRole.super   │
│                  │     │      Admin)      │     │     Admin)       │
└────────┬─────────┘     └────────┬─────────┘     └────────┬─────────┘
         │                        │                        │
         ▼                        ▼                        ▼
┌──────────────────┐     ┌──────────────────┐     ┌──────────────────┐
│  Main Screen     │     │  Business Admin  │     │  Super Admin     │
│  • Browse        │     │  Dashboard       │     │  Dashboard       │
│  • Search        │     │  • Products      │     │  • All Businesses│
│  • Book Services │     │  • Services      │     │  • All Bookings  │
│  • View Profile  │     │  • Bookings      │     │  • System Config │
└──────────────────┘     │  • Settings      │     └──────────────────┘
                         └──────────────────┘
```

## Business Management Flow

```
┌─────────────────────────────────────────────────────────────┐
│              BUSINESS MANAGEMENT WORKFLOW                    │
└─────────────────────────────────────────────────────────────┘

1. LOGIN
   ┌──────────────────┐
   │ Business Login   │
   │ • Email          │
   │ • Password       │
   └────────┬─────────┘
            │
            ▼ (Verify business ownership)
            │
2. DASHBOARD
   ┌──────────────────┐
   │ Dashboard        │
   │ • Business Info  │
   │ • Statistics     │
   │ • Quick Actions  │
   │ • Recent Bookings│
   └────────┬─────────┘
            │
            ▼
3. MANAGE
   ┌─────────────────────────────────────┐
   │                                     │
   ▼                                     ▼
┌──────────────┐                  ┌──────────────┐
│  PRODUCTS    │                  │  SERVICES    │
│              │                  │              │
│  Add New     │                  │  Add New     │
│  ├─ Name     │                  │  ├─ Name     │
│  ├─ Desc     │                  │  ├─ Desc     │
│  ├─ Price    │                  │  ├─ Price    │
│  ├─ Image    │                  │  ├─ Duration │
│  └─ Available│                  │  └─ Available│
│              │                  │              │
│  Edit        │                  │  Edit        │
│  Delete      │                  │  Delete      │
└──────────────┘                  └──────────────┘
   │                                     │
   └─────────────────┬───────────────────┘
                     ▼
            ┌──────────────────┐
            │   BOOKINGS       │
            │                  │
            │  View by Status: │
            │  • All           │
            │  • Pending       │
            │  • Confirmed     │
            │  • Completed     │
            │                  │
            │  Update Status:  │
            │  Pending →       │
            │  Confirmed →     │
            │  Completed       │
            └──────────────────┘
```

## Data Flow

```
┌─────────────────────────────────────────────────────────────┐
│                      DATA FLOW                               │
└─────────────────────────────────────────────────────────────┘

┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│   Flutter    │   API   │  Supabase    │  Query  │  PostgreSQL  │
│   Screens    │◄───────►│  Service     │◄───────►│  Database    │
└──────────────┘         └──────────────┘         └──────────────┘
      │                         │                         │
      │                         │                         │
      ▼                         ▼                         ▼
┌──────────────┐         ┌──────────────┐         ┌──────────────┐
│ UI Updates   │         │ Auth Check   │         │ Tables:      │
│ • Loading    │         │ • Session    │         │ • businesses │
│ • Success    │         │ • User Role  │         │ • products   │
│ • Error      │         │ • Ownership  │         │ • services   │
└──────────────┘         └──────────────┘         │ • bookings   │
                                                   │ • reviews    │
                                                   └──────────────┘
```

## Screen Hierarchy

```
App Root (main.dart)
│
├─ AuthGate (checks authentication)
│  │
│  ├─ Not Authenticated → AccountTypeScreen
│  │
│  └─ Authenticated
│     │
│     ├─ AppRole.user → MainScreen
│     │                  ├─ HomePage
│     │                  ├─ ExplorePage
│     │                  ├─ WishlistPage
│     │                  ├─ ServicesPage
│     │                  └─ ProfilePage
│     │                     ├─ EditProfilePage
│     │                     ├─ BusinessLoginScreen ✨
│     │                     └─ AboutUsScreen ✨
│     │
│     ├─ AppRole.businessAdmin → BusinessAdminDashboard ✨
│     │                           ├─ BusinessProductsScreen ✨
│     │                           ├─ BusinessServicesScreen ✨
│     │                           ├─ BusinessBookingsScreen ✨
│     │                           └─ BusinessSettingsScreen ✨
│     │
│     └─ AppRole.superAdmin → SuperAdminDashboard
```

✨ = Newly implemented screens

## Quick Reference

### Access Business Features:
1. Open app
2. Go to Profile (bottom nav)
3. Tap "Business Account"
4. Login with business credentials
5. Access dashboard

### Manage Products:
Dashboard → Products → Add/Edit/Delete

### Manage Services:
Dashboard → Services → Add/Edit/Delete

### View Bookings:
Dashboard → Bookings → Filter by status → Update status

### Edit Business:
Dashboard → Settings → Edit info → Save
