# Kantin UKK Flutter - Implementation Summary

## Project Overview
Complete Flutter mobile application for a digital canteen system with 3 user roles: Admin, Stan (Stall Owner), and Siswa (Student).

## Architecture

### Clean Architecture Pattern
```
Presentation Layer (Screens/Widgets)
    ↓
Business Logic Layer (Services)
    ↓
Data Layer (Models)
    ↓
External API
```

## API Integration

### Base Configuration
- Base URL: `https://ukk-p2.smktelkom-mlg.sch.id/api/`
- Authentication: Bearer Token
- Content-Type: application/json

### Service Layer Methods
Each service follows this pattern:
- `getAll{Entity}()` - Retrieve all records
- `get{Entity}ById(id)` - Retrieve single record
- `create{Entity}(model)` - Create new record
- `update{Entity}(id, model)` - Update existing record
- `delete{Entity}(id)` - Delete record

### Response Format
All services return:
```dart
{
  'success': bool,
  'data': dynamic,     // on success
  'message': String    // on error or success message
}
```

## State Management

### Current Implementation
- **setState()** for local component state
- **Global cart variable** for shopping cart (in menu_list_screen.dart)
- **SharedPreferences** for persistent storage (token, user data)

### Data Flow
```
User Action → Screen Event Handler → Service Call → API Request
    ↓
API Response → Service Processing → Result Return → Screen Update
    ↓
setState() → UI Rebuild
```

## Authentication Flow

### Login Process
1. User enters credentials in LoginScreen
2. AuthService.login() calls API
3. On success, save token and user data to SharedPreferences
4. Navigate to role-specific dashboard
5. Token automatically included in subsequent API calls

### Registration Process
1. User selects role (Stan/Siswa)
2. Form dynamically shows role-specific fields
3. AuthService.register() sends data to API
4. On success, redirect to login

### Logout Process
1. Call API logout endpoint (optional)
2. Clear SharedPreferences
3. Navigate back to LoginScreen

## Role-Based Features

### Admin Dashboard
Manages entire system:
- **Stan Management**: CRUD operations for stalls
- **Menu Management**: View and delete menus
- **Siswa Management**: View and delete students
- **Diskon Management**: CRUD for discounts
- **Transaction Management**: View all transactions

### Stan Dashboard
Manages own stall:
- **Menu Management**: CRUD for own menus only
- **Transaction Management**: View and update status for own orders
- **Status Updates**: Sequential status flow (belum dikonfirm → dimasak → diantar → sampai)

### Siswa Dashboard
Orders food:
- **Browse Menu**: View all menus with filters
- **Menu Detail**: See full details and add to cart
- **Shopping Cart**: Manage items and quantities
- **Checkout**: Create transaction
- **Order History**: Track order status in real-time

## Key Features Implementation

### Shopping Cart
**Location**: `lib/screens/siswa/menu_list_screen.dart`

```dart
List<CartItem> globalCart = [];  // Global state

// Add to cart
globalCart.add(CartItem(...));

// Update quantity
globalCart[index].qty++;

// Remove item
globalCart.removeAt(index);

// Calculate total
int total = globalCart.fold(0, (sum, item) => sum + item.totalHarga);
```

### Transaction Status Tracking
**Statuses**: belum dikonfirm → dimasak → diantar → sampai

**Visual Indicators**:
- Color coding per status
- Icons representing each stage
- Progress tracker in siswa transaction history
- Filter chips for status filtering

### Image Handling
**Package**: cached_network_image

```dart
CachedNetworkImage(
  imageUrl: menu.foto!,
  placeholder: (context, url) => LoadingIndicator(),
  errorWidget: (context, url, error) => PlaceholderIcon(),
)
```

### Currency Formatting
**Package**: intl

```dart
String formatCurrency(int amount) {
  final formatter = NumberFormat.currency(
    locale: 'id_ID',
    symbol: 'Rp ',
    decimalDigits: 0,
  );
  return formatter.format(amount);
}
```

## Widget Reusability

### CustomButton
- Consistent styling across app
- Built-in loading state
- Customizable colors and width

### CustomTextField
- Label and hint text
- Validation support
- Password obscuring
- Keyboard type configuration

### MenuCard
- Display menu with image
- Price formatting
- Action buttons (edit/delete/add to cart)
- Jenis (type) badge

### LoadingIndicator
- Consistent loading UI
- Optional message display

## Error Handling

### Pattern Used
```dart
try {
  final response = await http.get(...);
  if (response.statusCode == 200) {
    // Success
    return {'success': true, 'data': data};
  } else {
    // API error
    return {'success': false, 'message': errorMessage};
  }
} catch (e) {
  // Network/exception error
  return {'success': false, 'message': 'Error: ${e.toString()}'};
}
```

### UI Feedback
- **SnackBar** for success/error messages
- **AlertDialog** for confirmations
- **LoadingIndicator** during async operations
- **RefreshIndicator** for pull-to-refresh

## Data Validation

### Login/Register Forms
- Required field checks
- Minimum length validation
- Format validation (phone numbers)

### Transaction Creation
- Empty cart check
- Single stan validation
- Confirmation dialog before checkout

## UI/UX Patterns

### Navigation
- **Navigator.push()** for sub-screens
- **Navigator.pushReplacement()** for authentication flow
- **Navigator.pushAndRemoveUntil()** for logout

### Lists and Grids
- **ListView.builder** for scrollable lists
- **GridView.builder** for menu displays
- **ExpansionTile** for transaction details
- **RefreshIndicator** for data refresh

### Forms
- **Form** widget with **GlobalKey**
- **TextFormField** with validators
- **DropdownButton** for selections
- **FilterChip** for filters

## Theme Configuration

### Colors
```dart
Primary: Color(0xFFFF9800)      // Orange
Secondary: Color(0xFFFF5722)    // Deep Orange
Background: Colors.white
Text: Color(0xFF333333)         // Dark Grey
```

### Shapes
- Card elevation: 2
- Border radius: 8-12px
- Circular avatars for user icons

## Known Limitations & TODOs

### Current Limitations
1. **Cart Management**: Uses global variable instead of state management
2. **User Filtering**: Some screens show all data instead of filtering by current user
3. **Image Upload**: Not implemented (would need multipart form data)
4. **Offline Support**: No local database caching
5. **Token Refresh**: No automatic token refresh mechanism

### TODO Comments in Code
```dart
// TODO: Get from authenticated user
// TODO: Filter by current stan's id
// TODO: Filter by current siswa's id
```

## Testing Recommendations

### Manual Testing Checklist
- [ ] Login with all 3 roles
- [ ] Register new Stan and Siswa
- [ ] Admin: Create, Read, Update, Delete for all entities
- [ ] Stan: Manage own menus and transactions
- [ ] Stan: Update transaction status sequentially
- [ ] Siswa: Browse and filter menus
- [ ] Siswa: Add items to cart
- [ ] Siswa: Update cart quantities
- [ ] Siswa: Checkout and create transaction
- [ ] Siswa: View transaction history with status
- [ ] Logout from all roles
- [ ] Error handling (network errors, invalid inputs)

### Edge Cases to Test
- Empty cart checkout attempt
- Multiple stans in cart
- Rapid quantity changes
- Network timeout scenarios
- Invalid credentials
- Token expiration

## Future Enhancements

### State Management
Replace global cart with Provider or Bloc:
```dart
// With Provider
final cart = Provider.of<CartProvider>(context);
cart.addItem(item);

// With Bloc
context.read<CartBloc>().add(AddToCart(item));
```

### Image Upload
Implement using image_picker and multipart requests:
```dart
final image = await ImagePicker().pickImage(source: ImageSource.gallery);
var request = http.MultipartRequest('POST', url);
request.files.add(await http.MultipartFile.fromPath('foto', image.path));
```

### Push Notifications
For real-time order status updates using Firebase Cloud Messaging.

### Search Functionality
Add search bars to filter menus, transactions, etc.

### Analytics
Track user behavior, popular menus, sales statistics.

## File Dependencies

### Import Graph (Key Files)
```
main.dart
  → login_screen.dart
    → auth_service.dart
      → api_config.dart
      → user_model.dart
    → admin_dashboard.dart
    → stan_dashboard.dart
    → siswa_dashboard.dart
      → menu_list_screen.dart
        → menu_service.dart
          → menu_model.dart
        → cart_screen.dart
          → transaksi_service.dart
```

## Performance Considerations

### Optimizations Used
- **cached_network_image**: Prevents repeated image downloads
- **ListView.builder**: Lazy loading for large lists
- **const constructors**: Reduces widget rebuilds
- **RefreshIndicator**: Manual data refresh instead of polling

### Potential Bottlenecks
- Large transaction lists without pagination
- Cart state not persisted (lost on app restart)
- No image size optimization before display

## Security Considerations

### Implemented
- Token-based authentication
- Password obscuring in UI
- Confirmation dialogs for destructive actions
- Input validation on all forms

### Not Implemented (Production Needs)
- Password encryption in transit (depends on API)
- Certificate pinning
- Biometric authentication
- Rate limiting
- Session timeout

## Deployment Checklist

### Before Release
- [ ] Remove debug prints
- [ ] Test on multiple devices
- [ ] Handle all TODOs
- [ ] Add proper error messages
- [ ] Test with real API
- [ ] Add app icons
- [ ] Configure app name and version
- [ ] Generate signed APK/IPA
- [ ] Test on release build
- [ ] Prepare store listings

---

**Document Version**: 1.0  
**Last Updated**: February 8, 2026  
**Author**: Copilot Code Agent
