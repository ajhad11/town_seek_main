
import '../widgets/shop_card.dart';

class ShopData {
  static const List<Shop> allShops = [
    // --- From Home Screen (Nearby) ---
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1578916171728-46686eac8d58?auto=format&fit=crop&w=200&q=80",
      title: "Olive Super market",
      subtitle: "Grocery • 8.2 km",
      rating: "4.5",
      tags: ["Parking", "Offer", "Groceries"], // Added Groceries
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=200&q=80",
      title: "Black Bakery & Coolbar",
      subtitle: "Bakery & Cafe • 5.2 km",
      rating: "4.2",
      tags: ["Coffee", "Wifi", "Street parking", "Food"], // Added Food
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1556740738-b6a63e62c105?auto=format&fit=crop&w=200&q=80",
      title: "Tech Gadget Store",
      subtitle: "Electronics • 1.5 km",
      rating: "4.8",
      tags: ["Electronics", "Warranty"], // N/A to main 4 categories, but could be 'Electronics'
      isOpen: false,
    ),

    // --- From Groceries Page ---
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1555396273-367ea4eb4db5?auto=format&fit=crop&w=200&q=80",
      title: "Brixton Village",
      subtitle: "Bakery & Cafe • 5.2 km",
      rating: "4.5",
      tags: ["Organic", "Wifi", "Street parking", "Bakery", "Snacks", "Groceries"], // Added Groceries
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1542838132-92c53300491e?auto=format&fit=crop&w=200&q=80",
      title: "Whole Foods Market",
      subtitle: "Organic • 2.1 km",
      rating: "4.8",
      tags: ["Nearby", "Organic", "Vegan", "Fruits", "Vegetables", "Frozen Foods", "Groceries"], // Added Groceries
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1604719312566-8912e9227c6a?auto=format&fit=crop&w=200&q=80",
      title: "Walmart Supercenter",
      subtitle: "Superstore • 10.5 km",
      rating: "4.2",
      tags: ["Parking", "Offer", "Everything", "Frozen Foods", "Snacks", "Dairy Products", "Groceries"], // Added Groceries
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1583258292688-d0213dc5a3a8?auto=format&fit=crop&w=200&q=80",
      title: "Trader Joe's",
      subtitle: "Grocery • 3.5 km",
      rating: "4.9",
      tags: ["Nearby", "Friendly", "Snacks", "Frozen Foods", "Groceries"], // Added Groceries
      isOpen: false,
    ),

    // --- From Fashion Page ---
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1483985988355-763728e1935b?auto=format&fit=crop&w=200&q=80",
      title: "Zara",
      subtitle: "Clothing • 3.2 km",
      rating: "4.3",
      tags: ["Men's Clothing", "Ladies Clothing", "Kids Clothing", "Clothing", "Fashion"], // Added Fashion
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1560243563-062bfc001d68?auto=format&fit=crop&w=200&q=80",
      title: "H&M",
      subtitle: "Clothing • 2.5 km",
      rating: "4.1",
      tags: ["Men's Clothing", "Ladies Clothing", "Sustainable", "Sale", "Fashion"], // Added Fashion
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1543163521-1bf539c55dd2?auto=format&fit=crop&w=200&q=80",
      title: "Nike Store",
      subtitle: "Shoes • 4.0 km",
      rating: "4.6",
      tags: ["Footwear", "Accessories", "Men's Clothing", "Sports", "Fashion"], // Added Fashion
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1576053139778-7e32f2ae3cfd?auto=format&fit=crop&w=200&q=80",
      title: "Luxury Boutique",
      subtitle: "Boutiques • 1.0 km",
      rating: "4.8",
      tags: ["Accessories", "Ladies Clothing", "Luxury", "Nearby", "Fashion"], // Added Fashion
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1550009158-9ebf6d17dbb3?auto=format&fit=crop&w=200&q=80",
      title: "Foot Locker",
      subtitle: "Shoes • 5.5 km",
      rating: "4.2",
      tags: ["Footwear", "Accessories", "Parking", "Fashion"], // Added Fashion
      isOpen: false,
    ),

    // --- From Food Page ---
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1552566626-52f8b828add9?auto=format&fit=crop&w=200&q=80",
      title: "Burger King",
      subtitle: "Fast Food • 1.2 km",
      rating: "4.2",
      tags: ["Dining", "Take Away", "Home Delivery", "Non Veg", "Meals", "Fast Food", "Food"], // Added Food
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1509042239860-f550ce710b93?auto=format&fit=crop&w=200&q=80",
      title: "Starbucks",
      subtitle: "Coffee & Tea • 0.5 km",
      rating: "4.7",
      tags: ["Wifi", "Coffee", "Dining", "Take Away", "Veg", "Nearby", "Food"], // Added Food
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1514362545857-3bc16549766b?auto=format&fit=crop&w=200&q=80",
      title: "La Bella Vita",
      subtitle: "Italian • 3.0 km",
      rating: "4.6",
      tags: ["Dining", "Home Delivery", "Non Veg", "Meals", "Wine", "Food"], // Added Food
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1546069901-ba9599a7e63c?auto=format&fit=crop&w=200&q=80",
      title: "Green Salad Bar",
      subtitle: "Healthy • 4.5 km",
      rating: "4.3",
      tags: ["Dining", "Veg", "Home Delivery", "Meals", "Healthy", "Food"], // Added Food
      isOpen: false,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1551024709-8f23befc6f87?auto=format&fit=crop&w=200&q=80",
      title: "The Rusty Nail",
      subtitle: "Bar • 2.8 km",
      rating: "4.1",
      tags: ["Cool Bar", "Dining", "Non Veg", "Drinks", "Parking", "Food"], // Added Food
      isOpen: true,
    ),

    // --- Health Page ---
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1585435557343-3b092031a691?auto=format&fit=crop&w=200&q=80",
      title: "City Pharmacy",
      subtitle: "Pharmacy • 0.8 km",
      rating: "4.8",
      tags: ["Pharmacy", "Delivery", "Consultation", "Health"], 
      isOpen: true,
      facilities: ["Delivery", "Vaccination", "BP Check"],
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1534438327276-14e5300c3a48?auto=format&fit=crop&w=200&q=80",
      title: "FitFirst Gym",
      subtitle: "Gym & Fitness • 2.0 km",
      rating: "4.6",
      tags: ["Gym", "Training", "Yoga", "Sauna", "Parking", "Health"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=200&q=80",
      title: "City Hospital Chelari",
      subtitle: "Multi Speciality Hospital",
      rating: "4.5",
      tags: ["Hospital", "Laboratory", "Emergency", "Doctor", "24/7", "Health", "Pharmacy", "Parking"], 
      isOpen: true,
      facilities: ["24x7 Pharmacy", "ICU & Ventilator", "Advanced Lab", "X-Ray & MRI"],
      doctors: [
         Doctor(
           name: "Dr. Sarah Jennings",
           speciality: "Cardiologist",
           qualification: "MBBS, MD",
           availability: "10:00 AM - 02:00 PM",
         ),
          Doctor(
           name: "Dr. James Smith",
           speciality: "Neurologist",
           qualification: "MBBS, DM",
           availability: "04:00 PM - 08:00 PM",
         ),
         Doctor(
           name: "Dr. Emily Davis",
           speciality: "Pediatrician",
           qualification: "MBBS, DCH",
           availability: "09:00 AM - 01:00 PM",
         ),
      ],
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1519494026892-80bbd2d6fd0d?auto=format&fit=crop&w=200&q=80",
      title: "General Hospital",
      subtitle: "Hospital • 5.0 km",
      rating: "4.5",
      tags: ["Hospital", "Laboratory", "Emergency", "Doctor", "24/7", "Health"], 
      isOpen: true,
      facilities: ["Emergency", "X-Ray", "General Ward"],
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1629909613654-28e377c37b09?auto=format&fit=crop&w=200&q=80",
      title: "Smile Clinic",
      subtitle: "Dental Clinic • 1.5 km",
      rating: "4.9",
      tags: ["Clinics", "Dental", "Nearby", "Health"], 
      isOpen: true,
      facilities: ["X-Ray", "Cleaning", "Filling"],
      doctors: [
         Doctor(
           name: "Dr. John Doe",
           speciality: "Dentist",
           qualification: "BDS",
           availability: "10:00 AM - 05:00 PM",
         ),
      ]
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1571019614242-c5c5dee9f50b?auto=format&fit=crop&w=200&q=80",
      title: "Wellness Center",
      subtitle: "Wellness • 3.2 km",
      rating: "4.7",
      tags: ["Ayurvedha", "Massage", "Therapy", "Offers", "Health"], 
      isOpen: false,
    ),

    // --- Services ---
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1596464716127-f2a82984de30?auto=format&fit=crop&w=200&q=80",
      title: "Stitch Perfect",
      subtitle: "Tailoring • 2.5 km",
      rating: "4.8",
      tags: ["Tailor", "Stitching", "Alteration", "Clothes", "Parking"],
      isOpen: true,
      services: [
         ServiceItem(
           name: "Shirt",
           price: "Rs 300 /PCS",
           imageUrl: "https://images.unsplash.com/photo-1602810318383-e386cc2a3ccf?auto=format&fit=crop&w=300&q=80",
         ),
         ServiceItem(
           name: "Pant",
           price: "Rs 500 /PCS",
           imageUrl: "https://images.unsplash.com/photo-1594633312681-425c7b97ccd1?auto=format&fit=crop&w=300&q=80",
         ),
         ServiceItem(
           name: "Suit",
           price: "Rs 2500 /PCS",
           imageUrl: "https://images.unsplash.com/photo-1594938298603-c8148c47e356?auto=format&fit=crop&w=300&q=80",
         ),
         ServiceItem(
           name: "Kurta",
           price: "Rs 450 /PCS",
           imageUrl: "https://images.unsplash.com/photo-1589810635657-232948472d98?auto=format&fit=crop&w=300&q=80",
         ),
      ],
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1556906781-9a412961d289?auto=format&fit=crop&w=200&q=80",
      title: "City Rentals",
      subtitle: "Rental Shop • 4.0 km",
      rating: "4.3",
      tags: ["Rental", "Tuxedo", "Costumes", "Camera"],
      isOpen: true,
      services: [
         ServiceItem(
           name: "Camera Canon 5D",
           price: "Rs 1000 /Day", 
           imageUrl: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=300&q=80",
         ),
         ServiceItem(
            name: "Wedding Suit",
            price: "Rs 1500 /Day",
            imageUrl: "https://images.unsplash.com/photo-1593032465175-d81f0f371660?auto=format&fit=crop&w=300&q=80",
         ),
      ],
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=200&q=80",
      title: "Hotel Taj", // Renamed for sample match
      subtitle: "Hotel • 1.0 km",
      rating: "4.5",
      tags: ["Lodge", "Rooms", "Stay", "AC", "Parking"],
      isOpen: true,
      services: [
         ServiceItem(
           name: "2 bhk",
           price: "Rs 300 /Hours",
           imageUrl: "https://images.unsplash.com/photo-1502672260266-1c1ef2d93688?auto=format&fit=crop&w=300&q=80",
         ),
         ServiceItem(
           name: "1 bhk",
           price: "Rs 100 /Hours",
           imageUrl: "https://images.unsplash.com/photo-1522771753035-4a5035688d51?auto=format&fit=crop&w=300&q=80",
         ),
         ServiceItem(
           name: "Deluxe Room",
           price: "Rs 1000 /Night",
           imageUrl: "https://images.unsplash.com/photo-1611892440504-42a792e24d32?auto=format&fit=crop&w=300&q=80",
         ),
      ],
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1581092921461-eab62e97a780?auto=format&fit=crop&w=200&q=80",
      title: "Mobile Fix",
      subtitle: "Repair • 0.8 km",
      rating: "4.6",
      tags: ["Repair", "Mobile", "Laptop", "Electronics"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1595246140625-573b715d1128?auto=format&fit=crop&w=200&q=80",
      title: "Elite Tailors",
      subtitle: "Tailoring • 3.2 km",
      rating: "4.9",
      tags: ["Tailor", "Suits", "Custom", "Fabric"],
      isOpen: false,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1596464716127-f2a82984de30?auto=format&fit=crop&w=200&q=80",
      title: "Express Tailors",
      subtitle: "Alteration • 0.5 km",
      rating: "4.5",
      tags: ["Tailor", "Alteration", "Nearby", "Quick"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1566073771259-6a8506099945?auto=format&fit=crop&w=200&q=80",
      title: "Grand Stay Lodge",
      subtitle: "Luxury • 5.0 km",
      rating: "4.7",
      tags: ["Lodge", "Rooms", "Luxury", "Parking", "Offer"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1581092921461-eab62e97a780?auto=format&fit=crop&w=200&q=80",
      title: "Tech Care Center",
      subtitle: "Repair • 1.1 km",
      rating: "4.4",
      tags: ["Repair", "Laptop", "Mobile", "Nearby"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1516035069371-29a1b244cc32?auto=format&fit=crop&w=200&q=80",
      title: "Lens Master",
      subtitle: "Camera Rental • 3.5 km",
      rating: "4.6",
      tags: ["Rental", "Camera", "Photography", "Tech"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1566665797739-1674de7a421a?auto=format&fit=crop&w=200&q=80",
      title: "Cozy Stay Inn",
      subtitle: "Budget Lodge • 0.5 km",
      rating: "4.1",
      tags: ["Lodge", "Rooms", "Budget", "Nearby"],
      isOpen: true,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1581092160562-40aa08e78837?auto=format&fit=crop&w=200&q=80",
      title: "Watch Care",
      subtitle: "Watch Repair • 4.2 km",
      rating: "4.8",
      tags: ["Repair", "Watch", "Clock", "Service"],
      isOpen: false,
    ),
    Shop(
      imageUrl: "https://images.unsplash.com/photo-1594938298603-c8148c47e356?auto=format&fit=crop&w=200&q=80",
      title: "Suit Up",
      subtitle: "Men's Tailor • 2.8 km",
      rating: "4.9",
      tags: ["Tailor", "Suits", "Men", "Formal"],
      isOpen: true,
    ),
  ];
}

