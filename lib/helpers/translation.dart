import '../helpers/shared_value_helper.dart';

abstract class AppTranslation {
  static Map<String, Map<String, String>> translationsKeys = {
    "en": en,
    "ar": ar,
    "":ar
  };
}

final Map<String, String> en = {
  'Edifice':'Edifice',
  'home': 'Home',
  'cart': 'Cart',
  'profile': 'Profile',
  'categories': 'Categories',
  'featured categories': 'Featured Categories',
  'featured products': 'Featured Products',
  'orders': 'Orders',
  'my wishlist': 'My Wishlist',
  'messages': 'Messages',
  'wallet': 'Wallet',
  'my wallet': 'My Wallet',
  'login': 'Login',
  'logout': 'Logout',
  'view sub-categories': 'View Sub-Categories',
  'view products': 'View Products',
  'total amount' : 'Total Amount',
  'not logged in': 'Not logged in',
  'shopping cart': 'Shopping Cart',
  'update cart': 'UPDATE CART',
  'top categories': 'Top Categories',
  'log in': 'Log in',
  'sign up': 'Sign up',
  'email': 'Email',
  'phone': 'Phone',
  'password': 'Password',
  'retype password': 'Retype Password',
  'forgot password?': 'Forgot Password?',
  'Forget Password ?': 'Forget Password ?',
  'or, create a new account ?':'or, create a new account ?',
  'account': 'Account',
  'name': 'Name',
  'Send Code': 'Send Code',
  'Already have an Account ?': 'Already have an Account ?',
  'Password must be at least 6 character':'Password must be at least 6 character',
  'Notification':'Notification',
  'Purchase History':'Purchase History',
  'Earning Points':'Earning Points',
  'Refund Requests':'Refund Requests',
  'Wallet Balance':'Wallet Balance',
  'Search':'Search',
  'Search here ?':'Search here ?',
  'All':'All',
  'Paid':'Paid',
  'Unpaid':'Unpaid',
  'Confirmed':'Confirmed',
  'On Delivery':'On Delivery',
  'Delivered':'Delivered',
  'Check Balance':'Check Balance',
  'Ordered':'Ordered',
  'In wishlist':'In wishlist',
  'In your cart':'In your cart',
  'Search products from':'Search products from',
  'All Products of ':'All Products of ',
  'Price':'Price',
  'Club Point':'Club Point',
  'Quantity':'Quantity',
  'available':'available',
  'Total Price':'Total Price',
  'Seller':'Seller',
  'Chat with seller':'Chat with seller',
  'Descripiton':'Descripiton',
  'View More':'View More',
  'Video':'Video',
  'Reviews':'Reviews',
  'Seller Policy':'Seller Policy',
  'Return Policy':'Return Policy',
  'Support Policy':'Support Policy',
  'Products you may also like':'Products you may also like',
  'Top Selling Products from this seller':'Top Selling Products from this seller',
  'Buy Now':'Buy Now',
  'Add to Cart':'Add to Cart',
  'Show Less':'Show Less',
  'SEND':'SEND',
  'Color':'Color',
  'No related products':'No related products',
  'Title':'Title',
  'Message':'Message',
  'CLOSE':'CLOSE',
  'PROCEED TO SHIPPING':'PROCEED TO SHIPPING',
  'Earned Points':'Earned Points',
  'Filter':'Filter',
  'Products':'Products',
  'Sellers':'Sellers',
  'Brands':'Brands',
  'Sort':'Sort',
  'My Data':'My Data',
  'Sort Products By':'Sort Products By',
  'Default':'Default',
  'Price high to low':'Price high to low',
  'Price low to high':'Price low to high',
  'New Arrival':'New Arrival',
  'Popularity':'Popularity',
  'Top Rated':'Top Rated',
  'No recharges yet':'No recharges yet',
  'Amount':'Amount',
  'Enter Amount':'Enter Amount',
  'Wallet Recharge History':'Wallet Recharge History',
  'Proceed':'Proceed',
  'Amount cannot be empty':'Amount cannot be empty',
  'No More':'No More',
  'Loading More':'Loading More',
  'Are you sure to remove this address':'Are you sure to remove this address',
  'Enter Address':'Enter Address',
  'Select a city':'Select a city',
  'Select a country':'Select a country',
  'Address':'Address',
  'City':'City',
  'Enter City':'Enter City',
  'Postal Code':'Postal Code',
  'Enter Postal Code':'Enter Postal Code',
  'Country':'Country',
  'Enter Phone':'Enter Phone',
  'UPDATE':'UPDATE',
  'Addresses of user':'Addresses of user',
  'Double tap on an address to make it default':'Double tap on an address to make it default',
  'Please log in to see the cart items':'Please log in to see the cart items',
  'No Addresses is added':'No Addresses is added',
  'Shopping':'Shopping',
  'Top Sellers':'Top Sellers',
  'Todays Deal':'Todays Deal',
  'Flash Deal':'Flash Deal',
  'Search products':'Search products',
  'Recharge Wallet':'Recharge Wallet',
  'Account Number':'Account Number',
  'Press to Choose Image':'Press to Choose Image',
  'No Image Choosen':'No Image Choosen',
  'Pay with Bank':'Pay with Bank',
  'Enter name':'Enter name',
  'New Arrivals':'New Arrivals',
  'Top Selling Products':'Top Selling Products',
  'View All Products From This Seller':'View All Products From This Seller',
  'No data is available':'No data is available',
  'PROCEED TO CHECKOUT':'PROCEED TO CHECKOUT',
  'PLACE MY ORDER':'PLACE MY ORDER',
  'APPLY COUPON':'APPLY COUPON',
  'Order Details':'Order Details',
  'Order Code':'Order Code',
  'Order Date':'Order Date',
  'Payment Method':'Payment Method',
  'Payment Status':'Payment Status',
  'Delivery Status':'Delivery Status',
  'Shipping Address':'Shipping Address',
  'Shipping Method':'Shipping Method',
  'Ordered Product':'Ordered Product',
  'item':'item',
  'SUB TOTAL':'SUB TOTAL',
  'TAX':'TAX',
  'SHIPPING COST':'SHIPPING COST',
  'DISCOUNT':'DISCOUNT',
  'GRAND TOTAL':'GRAND TOTAL',
  'Refund Status':'Refund Status',
  'No items are ordered':'No items are ordered',
  'Order placed':'Order placed',
  'Secret Code':'Secret Code',
  'Copy Product Link':'Copy Product Link',
  'Copy Secret Code':'Copy Secret Code',
  'Share Options':'Share Options',
  'Copied':'Copied',
  'Privacy Policy':'Privacy Policy',
  'Terms and Conditions':'Terms and Conditions',
  'Your joining means that you agree to all of the':'Your joining means that you agree to all of the',
  'and':'and',
  'Join':'Join',
  'Edifice GameDif':'Edifice GameDif',
  'Full Name':'Full Name',
  'Login to':'Login to',
  'Save':'Save',
  'You are not logged in':'You are not logged in',
  'No sub categories available':'No sub categories available',
  'Digital Cart':'Digital Cart',
  'Goods Cart':'Goods Cart',
  'Cannot order less than':'Cannot order less than',
  'item(s) of this':'item(s) of this',
  'Cannot order more than':'Cannot order more than',
  'Price Range':'Price Range',
  'Minimum':'Minimum',
  'Maximum':'Maximum',
  'You can use sorting while searching for products':'You can use sorting while searching for products',
  'Are you sure to remove this item':'Are you sure to remove this item',
  'Cancel':'Cancel',
  'Confirm':'Confirm',
  'SHOW CART':'SHOW CART',
  'Added to cart':'Added to cart',
  'Coupon Code':'Coupon Code',
  'Enter coupon code':'Enter coupon code',
  'see details':'see details',
  'Cart is empty':'Cart is empty',
  'Enter the verification code that sent to your phone recently':'Enter the verification code that sent to your phone recently',
  'Enter the verification code that sent to your email recently':'Enter the verification code that sent to your email recently',
  'Resend Code':'Resend Code',
  'No Connection':'No Connection',
  'The phone number you entered is short':'The phone number you entered is short',
  'off':'OFF',
  'ADD':'ADD',
  'Checkout':'Checkout',
  'Pick Here':'Pick Here',
  'Calculating...':'Calculating...',
  'Your delivery location . . .':'Your delivery location . . .',
  'Go to address page':'Go to address page',
  'Delivery Location':'Delivery Location',
  'Points':'Points',
  'Language':'Language',
  'TotalPoints':'Total My Points',
  'No product is available':'No product is available',
  'No categories available':'No categories available',
  'No brands available':'No brands available',
  'No brand is available':'No brand is available',
  'notifications':'notifications'
};


final Map<String, String> ar = {
  'Edifice':'أدفيس',
  'home': 'الرئيسية',
  'cart': 'السلة',
  'profile': 'حسابي',
  'categories': 'الفئات',
  'featured categories': 'الفئات المميزه',
  'featured products': 'المنتجات المميزه',
  'orders': 'الطلبات',
  'my wishlist': 'المفضلة',
  'messages': 'الرسائل',
  'wallet': 'المحفظة',
  'my wallet': 'محفظتي',
  'login': 'تسجيل الدخول',
  'logout': 'تسجيل الخروج',
  'view sub-categories': 'الفئات الفرعيه',
  'view products': 'المنتجات',
  'total amount': 'إجمالي المبلغ',
  'not logged in': 'لم تسجل الدخول',
  'shopping cart': 'سلة التسوق',
  'update cart': 'تحديث السلة',
  'top categories': 'الفئات المميزه',
  'log in': 'تسجيل دخول',
  'sign up': 'تسجيل',
  'email': 'الايميل',
  'phone': 'الهاتف',
  'password': 'كلمة المرور',
  'retype password': 'تاكيد كلمة المرور',
  'forgot password?': 'هل نسيت كلمة المرور؟',
  'or, create a new account ?':'أو إنشاء حساب جديد؟',
  'account': 'حسابي',
  'name': 'الاسم',
  'Send Code': 'ارسال الكود',
  'Already have an Account ?': 'لديك حساب بالفعل؟',
  'Password must be at least 6 character':'يجب أن تتكون كلمة المرور من 6 أحرف على الأقل',
  'Forget Password ?': 'نسيت كلمة المرور ؟',
  'Notification':'الاشعارت',
  'Purchase History':'المشتريات',
  'Earning Points':'كسب النقاط',
  'Refund Requests':'طلبات الاسترداد',
  'Wallet Balance':'رصيد المحفظه',
  'Search':'بحث',
  'All':'الكل',
  'Paid':'مدفوع',
  'Unpaid':'غيرمدفوع',
  'Confirmed':'مؤكد',
  'On Delivery':'عند التسليم',
  'Delivered':'تم التسليم',
  'Check Balance':'التحقق من رصيدي',
  'Ordered':'عدد الطلبات',
  'In wishlist':'في المفضلة',
  'In your cart':'في السلة',
  'Search products from':'البحث عن منتجات من',
  'All Products of ':'جميع منتجات ',
  'Price':'السعر',
  'Club Point':'النقاط',
  'Quantity':'الكميه',
  'available':'المتوفره',
  'Total Price':'السعر الكلي',
  'Seller':'البائع',
  'Chat with seller':'الدردشه مع البائع',
  'Descripiton':'الوصف',
  'View More':'عرض المزيد',
  'Video':'فيديو',
  'Reviews':'التعليقات',
  'Seller Policy':'سياسه البائع',
  'Return Policy':'سياسه الارجاع',
  'Support Policy':'سياسه الدعم',
  'Products you may also like':'منتجات قد تعجبك',
  'Top Selling Products from this seller':'المنتجات الاكثر مبيعا من هذا البائع',
  'Buy Now':'اشتر الان',
  'Add to Cart':'اضف الى السله',
  'Show Less':'اخفاء',
  'SEND':'ارسال',
  'Color':'اللون',
  'No related products':'لا توجد منتجات متعلقة',
  'Title':'العنوان',
  'Message':'الرساله',
  'CLOSE':'اغلاق',
  'PROCEED TO SHIPPING':'بيانات الشحن',
  'Earned Points':'النقاط المكتسبه',
  'Filter':'تصفية',
  'Products':'المنتجات',
  'Sellers':'البائعين',
  'Brands':'الماركات',
  'Sort':'ترتيب',
  'My Data':'بياناتي',
  'Search here ?':'ابحث هنا ؟',
  'Sort Products By':'ترتيب المنتجات حسب',
  'Default':'افتراضي',
  'Price high to low':'من اعلى سعر الى اقل سعر',
  'Price low to high':'من اقل سعر الى اعلى سعر',
  'New Arrival':'وصل حديثا',
  'Popularity':'اكثر رواجا',
  'Top Rated':'اعلى تقييما',
  'No recharges yet':'لا توجد عمليات إعادة شحن حتى الآن',
  'Amount':'المبلغ',
  'Enter Amount':'ادخل المبلغ',
  'Wallet Recharge History':'سجل شحن المحفظة',
  'Proceed':'متابعه',
  'Amount cannot be empty':'لا يمكن ان يكون المبلغ فارغا',
  'No More':'لا يوجد بيانات اكثر',
  'Loading More':'تحميل المزيد',
  'Are you sure to remove this address':'هل أنت متأكد من إزالة هذا العنوان',
  'Enter Address':'ادخل العنوان',
  'Select a city':'اختر المدينة',
  'Select a country':'اختر الدولة',
  'Address':'العنوان',
  'City':'المدينة',
  'Enter City':'ادخل المدينة',
  'Postal Code':'الرمز البريدي',
  'Enter Postal Code':'ادخل الرمز البريدي',
  'Country':'الدولة',
  'Enter Phone':'ادخل الهاتف',
  'UPDATE':'تحديث',
  'Addresses of user':'عناوين المستخدم',
  'Double tap on an address to make it default':'انقر مرتين على العنوان لجعله افتراضيًا',
  'Please log in to see the cart items':'الرجاء تسجيل الدخول لرؤية عناصر سلة التسوق',
  'No Addresses is added':'لم تتم إضافة أي عناوين',
  'Shopping':'تسوق',
  'Top Sellers':'بائعيين مميزين',
  'Todays Deal':'عروض يومية',
  'Flash Deal':'صفقات',
  'Search products':'بحث المنتجات',
  'Recharge Wallet':'شحن المحفظة',
  'Account Number':'رقم الحساب',
  'Press to Choose Image':'اضغط هنا لاختيار الصورة',
  'No Image Choosen':'لم يتم تحديد اي صورة',
  'Pay with Bank':'الدفع عن طريق البنك',
  'Enter name':'ادخل الاسم',
  'New Arrivals':'الواصل حديثا',
  'Top Selling Products':'المنتجات الاكثر مبيعا',
  'View All Products From This Seller':'جميع منتجات البائع',
  'No data is available':'لا يوجد بيانات',
  'PROCEED TO CHECKOUT':'بيانات الدفع',
  'PLACE MY ORDER':'اكمال طلبي',
  'APPLY COUPON':'كوبون التخفيض',
  'Order Details':'تفاصيل الطلب',
  'Order Code':'رقم الطلب',
  'Order Date':'تاريخ الطلب',
  'Payment Method':'طريقة الدفع',
  'Payment Status':'حالة الدفع',
  'Delivery Status':'حالة التسليم',
  'Shipping Address':'عنوان الشحنه',
  'Shipping Method':'طريقة الشحن',
  'Ordered Product':'منتجات الطلب',
  'item':'حبه',
  'SUB TOTAL':'مبلغ اجمالي',
  'TAX':'الضريبه',
  'SHIPPING COST':'تكلفة الشحن',
  'DISCOUNT':'تخفيض',
  'GRAND TOTAL':'المجموع الاجمالي',
  'Refund Status':'حالة الاسترداد',
  'No items are ordered':'لا يوجد منتجات في الطلبية',
  'Order placed':'انتظار موافقة',
  'Secret Code':'الرمز السري للبطاقة',
  'Copy Product Link':'نسخ رابط المنتج',
  'Copy Secret Code':'نسخ الرمز السري للبطاقة',
  'Share Options':'خيارات المشاركة',
  'Copied':'تم النسخ',
  'Privacy Policy':'سياسة الخصوصية',
  'Terms and Conditions':'الشروط والاحكام',
  'Your joining means that you agree to all of the':'انضمامك يعني موافقتك على جميع',
  'and':'و',
  'Join':'انضم ل ',
  'Edifice GameDif':'أدفيس للالعاب',
  'Full Name':'الاسم الثلاثي',
  'Login to':'الدخول ل',
  'Save':'حفظ',
  'You are not logged in':'لم تسجل الدخول',
  'No sub categories available':'لا يوجد فئات فرعيه',
  'Digital Cart':'السلة الرقمية',
  'Goods Cart':'السلة السعلية',
  'Cannot order less than':'لا يمكن طلب اقل من',
  'item(s) of this':'من هذا الصنف',
  'Cannot order more than':'لا يمكن طلب اكثر من',
  'Price Range':'حدود السعر',
  'Minimum':'الحد الادنى',
  'Maximum':'الحد الاعلى',
  'You can use sorting while searching for products':'تستطيع استخدام الترتيب عند تحديد خيار المنتجات.',
  'Are you sure to remove this item':'هل انت متاكد من حذف هذا العنصر',
  'Cancel':'الغاء',
  'Confirm':'تاكيد',
  'Added to cart':'تم الاضافة للسلة',
  'SHOW CART':'فتح السلة',
  'Coupon Code':'كود التخفيض',
  'Enter coupon code':'ادخل كود التخفيض',
  'see details':'رؤية التفاصيل',
  'Cart is empty':'السلة فارغة',
  'Enter the verification code that sent to your phone recently':'أدخل رمز التحقق الذي تم إرساله إلى هاتفك',
  'Enter the verification code that sent to your email recently':'أدخل رمز التحقق الذي تم إرساله إلى بريدك الإلكتروني',
  'Resend Code':'أعد ارسال الرمز',
  'No Connection':'تاكد من اتصالك بالنت',
  'The phone number you entered is short':'رقم الهاتف الذي أدخلتة قصير',
  'off':'خصم',
  'ADD':'إضافة',
  'Checkout':'الدفع',
  'Pick Here':'اختار هنا',
  'Calculating...':'جاري الاحتساب...',
  'Your delivery location . . .':'موقع التسليم الخاص بك...',
  'Go to address page':'اذهب الى صفحة العناوين',
  'Delivery Location':'موقع التسليم',
  'Points':'نقطة',
  'Language':'اللغة',
  'TotalPoints':'اجمالي نقاطي',
  'No product is available':'لا توجد منتجات',
  'No categories available':'لا توجد فئات',
  'No brands available':'لا توجد ماركات',
  'No brand is available':'لا توجد ماركات',
  'notifications':'الاشعارات'
};