import 'dart:async';
import 'dart:collection';

// Model Data
// a. Kelas User
class User {
  String name;
  int age;
  List<Product>? products;
  Role? role;

  User(this.name, this.age);
}

// b. Enum Role
enum Role { Admin, Customer }

// c. Inheritance
// Subclass AdminUser
class AdminUser extends User {
  AdminUser(String name, int age) : super(name, age) {
    role = Role.Admin;
  }

  // Fungsi untuk menambah produk
  void addProduct(Product product, Map<String, Product> productCatalog) {
    if (productCatalog.containsKey(product.productName)) {
      print('Produk ${product.productName} sudah ada.');
    } else {
      productCatalog[product.productName] = product;
      print('Produk ${product.productName} ditambahkan oleh Admin.');
    }
  }

  // Fungsi untuk menghapus produk
  void removeProduct(String productName, Map<String, Product> productCatalog) {
    if (productCatalog.remove(productName) != null) {
      print('Produk $productName dihapus oleh Admin.');
    } else {
      print('Produk $productName tidak ditemukan.');
    }
  }
}

// Subclass CustomerUser
class CustomerUser extends User {
  CustomerUser(String name, int age) : super(name, age) {
    role = Role.Customer;
  }

  // Fungsi untuk melihat daftar produk
  void viewProducts(Map<String, Product> productCatalog) {
    print('Daftar produk:');
    productCatalog.forEach((name, product) {
      print(
          '- ${product.productName}, Harga: ${product.price}, Stok: ${product.inStock ? 'Tersedia' : 'Kosong'}');
    });
  }
}

// Kelas Product
class Product {
  String productName;
  double price;
  bool inStock;

  Product(this.productName, this.price, this.inStock);
}

// d. Null Safety & Late Initialization
class EcommerceSystem {
  late Map<String, Product> productCatalog;
  Set<String> productNames = {};

  EcommerceSystem() {
    productCatalog = {};
  }
}

// e. Exception Handling
void addProductSafely(
    AdminUser admin, Product product, Map<String, Product> productCatalog) {
  try {
    if (!product.inStock) {
      throw Exception(
          'Produk ${product.productName} tidak tersedia dalam stok.');
    }
    admin.addProduct(product, productCatalog);
  } catch (e) {
    print('Kesalahan: $e');
  }
}

// f. Asynchronous Programming
Future<void> fetchProductDetails(String productName) async {
  print('Mengambil detail produk $productName...');
  await Future.delayed(Duration(seconds: 2));
  print('Detail produk $productName berhasil diambil.');
}

void main() async {
  // Inisialisasi sistem
  var ecommerceSystem = EcommerceSystem();

  // Inisialisasi Admin dan Customer
  var admin = AdminUser('Admin A', 30);
  var customer = CustomerUser('Customer B', 25);

  // Menambahkan produk
  var product1 = Product('Laptop', 15000.0, true);
  var product2 = Product('Smartphone', 8000.0, false);

  addProductSafely(admin, product1, ecommerceSystem.productCatalog);
  addProductSafely(admin, product2, ecommerceSystem.productCatalog);

  // Customer melihat produk
  customer.viewProducts(ecommerceSystem.productCatalog);

  // Menjalankan fungsi asinkron
  await fetchProductDetails('Laptop');
}
