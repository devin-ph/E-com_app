import 'package:e_com_app/models/cart_item.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../../models/product.dart';
import '../../../providers/cart_provider.dart';
import '../../../utils/formatters.dart';
import '../../../utils/product_localization.dart';

const List<String> _defaultSizes = ['S', 'M', 'L', 'XL', 'XXL'];
const Map<int, String> _productTitlesVi = {
  // Mỹ phẩm (1-5)
  1: 'Mascara tạo mi Essence Lash Princess',
  2: 'Bảng phấn mắt 16 ô kèm gương',
  3: 'Phấn phủ dạng hộp tiện dụng',
  4: 'Son môi đỏ quyến rũ',
  5: 'Sơn móng tay màu đỏ',
  // Nước hoa (6-10)
  6: 'Nước hoa Calvin Klein CK One',
  7: 'Nước hoa Chanel Coco Noir',
  8: 'Nước hoa Dior J\'adore',
  9: 'Nước hoa Dolce Shine',
  10: 'Nước hoa Gucci Bloom',
  // Nội thất (11-15)
  11: 'Giường ngủ đôi Annibale Colombo cao cấp',
  12: 'Ghế sofa Annibale Colombo',
  13: 'Tủ đầu giường gỗ anh đào châu Phi',
  14: 'Ghế hội nghị điều hành Knoll Saarinen',
  15: 'Chậu rửa mặt gỗ có gương treo tường',
  // Tạp hóa (16-42)
  16: 'Táo tươi nhập khẩu',
  17: 'Thịt bò bít-tết tươi',
  18: 'Thức ăn cho mèo Cat Food',
  19: 'Thịt gà tươi sạch',
  20: 'Dầu ăn thực vật tinh luyện',
  21: 'Dưa chuột tươi',
  22: 'Thức ăn cho chó Pedigree',
  23: 'Trứng gà tươi sạch',
  24: 'Cá phi lê tươi',
  25: 'Ớt chuông xanh tươi',
  26: 'Ớt xanh tươi',
  27: 'Mật ong rừng nguyên chất',
  28: 'Kem que mát lạnh',
  29: 'Nước ép trái cây tươi',
  30: 'Kiwi tươi nhập khẩu',
  31: 'Chanh tươi',
  32: 'Sữa tươi tiệt trùng',
  33: 'Dâu tằm tươi',
  34: 'Cà phê Nescafé hòa tan',
  35: 'Khoai tây tươi',
  36: 'Bột Protein thể hình',
  37: 'Hành tây đỏ tươi',
  38: 'Gạo trắng hạt dài',
  39: 'Nước ngọt có ga',
  40: 'Dâu tây tươi',
  41: 'Hộp khăn giấy tiện dụng',
  42: 'Nước uống tinh khiết',
  // Trang trí nhà (43-47)
  43: 'Xích đu trang trí phòng khách',
  44: 'Khung ảnh cây gia đình',
  45: 'Cây trang trí để nhà',
  46: 'Chậu cây xanh trang trí',
  47: 'Đèn bàn trang trí nội thất',
  // Phụ kiện bếp (48-77)
  48: 'Thìa xới cơm gỗ tre tự nhiên',
  49: 'Cốc nhôm cao cấp màu đen',
  50: 'Dụng cụ đánh trứng màu đen',
  51: 'Máy xay sinh tố để bàn',
  52: 'Chảo thép carbon chịu nhiệt',
  53: 'Thớt cắt thực phẩm đa năng',
  54: 'Dụng cụ vắt cam chanh màu vàng',
  55: 'Dụng cụ thái trứng tiện dụng',
  56: 'Bếp điện gia đình đa năng',
  57: 'Rây lọc mịn nhuyễn',
  58: 'Nĩa dùng bữa đa năng',
  59: 'Ly thủy tinh cao cấp',
  60: 'Dụng cụ bào thực phẩm màu đen',
  61: 'Máy xay cầm tay đa tốc độ',
  62: 'Khay làm đá viên',
  63: 'Rây bếp đa năng',
  64: 'Dao bếp cao cấp chống gỉ',
  65: 'Hộp cơm giữ nhiệt tiện lợi',
  66: 'Lò vi sóng gia đình đa năng',
  67: 'Giá treo cốc gỗ',
  68: 'Chảo chiên chống dính',
  69: 'Đĩa ăn sứ cao cấp',
  70: 'Kẹp gắp thực phẩm màu đỏ',
  71: 'Nồi inox nắp kính trong suốt',
  72: 'Xẻng lật thức ăn',
  73: 'Kệ đựng gia vị bếp',
  74: 'Muỗng/Thìa ăn',
  75: 'Khay phục vụ đa năng',
  76: 'Cây cán bột gỗ',
  77: 'Dụng cụ gọt vỏ màu vàng',
  // Laptop (78-82)
  78: 'Laptop Apple MacBook Pro 14 inch',
  79: 'Laptop Asus Zenbook Pro hai màn hình',
  80: 'Laptop Huawei Matebook X Pro',
  81: 'Laptop Lenovo Yoga 920 dạng gập',
  82: 'Laptop Dell XPS 13 mỏng nhẹ cao cấp',
  // Áo nam (83-87)
  83: 'Áo sơ mi nam kẻ xanh đen',
  84: 'Áo thun nam Gigabyte Aorus gaming',
  85: 'Áo sơ mi nam kẻ caro',
  86: 'Áo sơ mi nam tay ngắn',
  87: 'Áo sơ mi nam kẻ ô vuông',
  // Giày nam (88-92)
  88: 'Giày Nike Air Jordan 1 đỏ đen',
  89: 'Giày bóng chày Nike nam',
  90: 'Giày thể thao Puma Future Rider',
  91: 'Giày sneaker trắng đỏ thời trang',
  92: 'Giày sneaker thể thao trắng đỏ',
  // Đồng hồ nam (93-98)
  93: 'Đồng hồ nam dây da nâu',
  94: 'Đồng hồ cơ Longines Master Collection',
  95: 'Đồng hồ Rolex Cellini mặt đen',
  96: 'Đồng hồ Rolex Cellini Moonphase',
  97: 'Đồng hồ Rolex Datejust cao cấp',
  98: 'Đồng hồ lặn Rolex Submariner',
  // Phụ kiện mobile (99-112)
  99: 'Loa thông minh Amazon Echo Plus',
  100: 'Tai nghe không dây Apple AirPods',
  101: 'Tai nghe chụp tai Apple AirPods Max',
  102: 'Sạc không dây Apple Airpower',
  103: 'Loa thông minh Apple HomePod Mini',
  104: 'Cáp sạc iPhone chính hãng',
  105: 'Pin dự phòng không dây Apple MagSafe',
  106: 'Đồng hồ Apple Watch Series 4 vàng',
  107: 'Tai nghe không dây Beats Flex',
  108: 'Ốp lưng silicone iPhone 12 màu tím',
  109: 'Gậy chụp ảnh Monopod',
  110: 'Đèn selfie kẹp điện thoại',
  111: 'Gậy selfie đa năng',
  112: 'Chân đế camera studio chuyên dụng',
  // Xe máy (113-117)
  113: 'Xe máy đa năng tiện dụng',
  114: 'Xe mô tô Kawasaki Z800',
  115: 'Xe mô tô thể thao MotoGP',
  116: 'Xe tay ga tiện dụng',
  117: 'Xe mô tô thể thao',
  // Chăm sóc da (118-120)
  118: 'Xà phòng rửa tay Attitude Super Leaves',
  119: 'Sữa tắm dưỡng ẩm Olay Shea Butter',
  120: 'Kem dưỡng thể và mặt Vaseline Men',
  // Điện thoại (121-136)
  121: 'Điện thoại iPhone 5s',
  122: 'Điện thoại iPhone 6',
  123: 'Điện thoại iPhone 13 Pro',
  124: 'Điện thoại iPhone X',
  125: 'Điện thoại Oppo A57',
  126: 'Điện thoại Oppo F19 Pro Plus',
  127: 'Điện thoại Oppo K1',
  128: 'Điện thoại Realme C35',
  129: 'Điện thoại Realme X',
  130: 'Điện thoại Realme XT',
  131: 'Điện thoại Samsung Galaxy S7',
  132: 'Điện thoại Samsung Galaxy S8',
  133: 'Điện thoại Samsung Galaxy S10',
  134: 'Điện thoại Vivo S1',
  135: 'Điện thoại Vivo V9',
  136: 'Điện thoại Vivo X21',
  // Phụ kiện thể thao (137-153)
  137: 'Bóng bầu dục Mỹ',
  138: 'Bóng chày',
  139: 'Găng tay bóng chày',
  140: 'Bóng rổ cao cấp',
  141: 'Vành rổ bóng rổ',
  142: 'Bóng cricket',
  143: 'Gậy đánh bóng cricket',
  144: 'Mũ bảo hiểm cricket',
  145: 'Khung cổng cricket',
  146: 'Cầu lông vũ',
  147: 'Bóng đá chính hãng',
  148: 'Bóng golf',
  149: 'Gậy golf sắt',
  150: 'Gậy bóng chày kim loại',
  151: 'Bóng tennis',
  152: 'Vợt tennis cao cấp',
  153: 'Bóng chuyền cao cấp',
  // Kính mát (154-158)
  154: 'Kính mát đen phong cách',
  155: 'Kính mát cổ điển thời trang',
  156: 'Kính mát xanh đen nổi bật',
  157: 'Kính mát dự tiệc',
  158: 'Kính mát phong cách đường phố',
  // Máy tính bảng (159-161)
  159: 'Máy tính bảng iPad Mini 2021',
  160: 'Máy tính bảng Samsung Galaxy Tab S8 Plus',
  161: 'Máy tính bảng Samsung Galaxy Tab trắng',
  // Áo nữ / Đầm ngắn (162-166)
  162: 'Đầm tay ngắn màu xanh',
  163: 'Đầm mùa hè nữ',
  164: 'Đầm màu xám thời trang',
  165: 'Đầm ngắn dễ thương',
  166: 'Đầm kẻ caro thời trang',
  // Xe cộ (167-171)
  167: 'Xe Chrysler 300 Touring',
  168: 'Xe Dodge Charger SXT',
  169: 'Xe SUV Dodge Hornet GT Plus',
  170: 'Xe SUV Dodge Durango SXT',
  171: 'Xe MPV Chrysler Pacifica Touring',
  // Túi nữ (172-176)
  172: 'Túi xách nữ màu xanh da trời',
  173: 'Túi da nữ Heshe cao cấp',
  174: 'Túi xách nữ Prada',
  175: 'Balo nữ da PU màu trắng',
  176: 'Túi xách nữ màu đen thanh lịch',
  // Đầm nữ (177-181)
  177: 'Đầm dạ hội nữ màu đen',
  178: 'Áo corset da kèm chân váy',
  179: 'Áo corset kèm chân váy đen',
  180: 'Đầm nữ họa tiết hạt đậu',
  181: 'Bộ vest đỏ đen Marni',
  // Trang sức nữ (182-184)
  182: 'Khuyên tai đá pha lê xanh',
  183: 'Bông tai elip xanh thời trang',
  184: 'Bông tai chủ đề nhiệt đới',
  // Giày nữ (185-189)
  185: 'Dép nữ đen nâu thoải mái',
  186: 'Giày cao gót Calvin Klein',
  187: 'Giày nữ màu vàng thời trang',
  188: 'Giày nữ Pampi phong cách',
  189: 'Giày nữ màu đỏ quyến rũ',
  // Đồng hồ nữ (190-194)
  190: 'Đồng hồ nữ IWC Ingenieur tự động thép',
  191: 'Đồng hồ nữ Rolex Cellini Moonphase',
  192: 'Đồng hồ nữ Rolex Datejust',
  193: 'Đồng hồ nữ mạ vàng sang trọng',
  194: 'Đồng hồ đeo tay nữ thời trang',
};

const Map<String, String> _categoryLabelsVi = {
  'beauty': 'Mỹ phẩm',
  'fragrances': 'Nước hoa',
  'furniture': 'Nội thất',
  'groceries': 'Tạp hóa',
  'home-decoration': 'Trang trí nhà',
  'kitchen-accessories': 'Phụ kiện bếp',
  'laptops': 'Laptop',
  'mens-shirts': 'Áo nam',
  'mens-shoes': 'Giày nam',
  'mens-watches': 'Đồng hồ nam',
  'mobile-accessories': 'Phụ kiện mobile',
  'motorcycle': 'Xe máy',
  'skin-care': 'Chăm sóc da',
  'smartphones': 'Điện thoại',
  'sports-accessories': 'Phụ kiện thể thao',
  'sunglasses': 'Kính mát',
  'tablets': 'Máy tính bảng',
  'tops': 'Áo nữ',
  'vehicle': 'Xe cộ',
  'womens-bags': 'Túi nữ',
  'womens-dresses': 'Đầm nữ',
  'womens-jewellery': 'Trang sức nữ',
  'womens-shoes': 'Giày nữ',
  'womens-watches': 'Đồng hồ nữ',
};

const List<String> _electronicsCapacities = ['128Gb', '256Gb', '512Gb', '1Tb'];
const List<String> _fragranceSizes = ['Chiết 100ml', 'Chiết 150ml'];
const List<String> _skinCareSizes = ['100ml', '200ml', '500ml'];
const List<String> _shoeSizes = ['36', '37', '38', '39', '40', '41', '42'];
const List<String> _weightedSizes = ['1kg', '2kg', '5kg'];
const List<String> _liquidSizes = ['1 lít', '1,5 lít', '2 lít'];
const List<String> _eggPackSizes = ['10 quả', '20 quả', '50 quả'];
const Set<int> _weightedGroceryIds = {
  16, // Táo
  17, // Thịt bò
  18, // Thức ăn cho mèo
  19, // Thịt gà
  21, // Dưa chuột
  22, // Thức ăn cho chó
  24, // Cá phi lê
  25, // Ớt chuông
  26, // Ớt xanh
  30, // Kiwi
  31, // Chanh
  33, // Dâu tằm
  35, // Khoai tây
  37, // Hành tây
  38, // Gạo trắng
  40, // Dâu tây
};
const Set<int> _liquidProductIds = {
  20, // Dầu ăn
  27, // Mật ong
  29, // Nước ép
  32, // Sữa tươi
  39, // Nước ngọt
  42, // Nước uống
};
const Set<int> _eggProductIds = {23}; // Trứng gà
const Set<int> _quantityOnlyProductIds = {
  28, // Kem
  34, // Cà phê
  36, // Bột protein
  41, // Hộp giấy
};
const List<Map<String, dynamic>> _defaultColors = [
  {'label': 'Đen', 'value': 'Đen', 'color': Colors.black},
  {'label': 'Trắng', 'value': 'Trắng', 'color': Colors.white},
  {'label': 'Đỏ', 'value': 'Đỏ', 'color': Colors.red},
  {'label': 'Xanh', 'value': 'Xanh', 'color': Colors.blue},
  {'label': 'Vàng', 'value': 'Vàng', 'color': Colors.amber},
];

const List<String> _jewelrySizes = ['13', '14', '15', '16', '17'];
const List<Map<String, dynamic>> _jewelryColors = [
  {'label': 'Bạc', 'value': 'Bạc', 'color': Color(0xFFC0C0C0)},
  {'label': 'Vàng kim', 'value': 'Vàng kim', 'color': Color(0xFFD4AF37)},
];

class AddToCartBottomSheet extends StatefulWidget {
  final Product product;
  final bool buyNow;

  const AddToCartBottomSheet({
    super.key,
    required this.product,
    this.buyNow = false,
  });

  static Future<void> show(
    BuildContext context,
    Product product, {
    bool buyNow = false,
  }) {
    return showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => AddToCartBottomSheet(product: product, buyNow: buyNow),
    );
  }

  @override
  State<AddToCartBottomSheet> createState() => _AddToCartBottomSheetState();
}

class _AddToCartBottomSheetState extends State<AddToCartBottomSheet> {
  String _selectedSize = _defaultSizes.first;
  String _selectedColor = _defaultColors.first['value'] as String;
  int _quantity = 1;

  static const double _vndStepByCapacity = 500000;
  static const double _vndStepByFragranceSize = 599000;
  static const double _vndStepByWeight2kg = 99000;
  static const double _vndStepByWeight5kg = 139000;
  static const double _vndStepByLiquidSize = 55000;
  static const double _vndStepByEgg20 = 30000;
  static const double _vndStepByEgg50 = 61000;
  static const double _vndStepBySkinCare200 = 99000;
  static const double _vndStepBySkinCare500 = 139000;
  static const double _vndPerUsd = 25000;

  bool get _isJewelry {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'womens-jewellery' ||
        cat == 'mens-watches' ||
        cat == 'womens-watches' ||
        cat == 'sunglasses';
  }

  bool get _isElectronics {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'smartphones' ||
        cat == 'laptops' ||
        cat == 'tablets' ||
        cat == 'mobile-accessories';
  }

  bool get _isSmartphone {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'smartphones';
  }

  bool get _isMobileAccessory {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'mobile-accessories';
  }

  bool get _isFragrance {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'fragrances';
  }

  bool get _isSkinCare {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'skin-care';
  }

  bool get _isShoes {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'mens-shoes' || cat == 'womens-shoes';
  }

  bool get _isWeightedGrocery {
    return _weightedGroceryIds.contains(widget.product.id);
  }

  bool get _isLiquidProduct {
    return _liquidProductIds.contains(widget.product.id);
  }

  bool get _isEggProduct {
    return _eggProductIds.contains(widget.product.id);
  }

  bool get _isKitchenAccessory {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'kitchen-accessories';
  }

  bool get _isSunglasses {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'sunglasses';
  }

  bool get _isMotorcycle {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'motorcycle';
  }

  bool get _isWomensBag {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'womens-bags';
  }

  bool get _isVehicle {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'vehicle';
  }

  bool get _isSportsAccessory {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'sports-accessories';
  }

  bool get _isHomeDecoration {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'home-decoration';
  }

  bool get _isFurniture {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'furniture';
  }

  bool get _isBeauty {
    final cat = widget.product.category.toLowerCase().trim();
    return cat == 'beauty';
  }

  bool get _isQuantityOnlyProduct {
    return _isKitchenAccessory ||
        _isSunglasses ||
        _isVehicle ||
        _isSportsAccessory ||
        _isHomeDecoration ||
        _isFurniture ||
        _isBeauty ||
        _isMobileAccessory ||
        _quantityOnlyProductIds.contains(widget.product.id);
  }

  List<String> get _sizes {
    if (_isQuantityOnlyProduct) return const [];
    if (_isElectronics) return _electronicsCapacities;
    if (_isFragrance) return _fragranceSizes;
    if (_isSkinCare) return _skinCareSizes;
    if (_isShoes) return _shoeSizes;
    if (_isEggProduct) return _eggPackSizes;
    if (_isLiquidProduct) return _liquidSizes;
    if (_isWeightedGrocery) return _weightedSizes;
    if (_isJewelry) return _jewelrySizes;
    return _defaultSizes;
  }

  List<Map<String, dynamic>> get _colors =>
      _isJewelry ? _jewelryColors : _defaultColors;

  int get _capacityStepIndex {
    if (!_isElectronics) return 0;
    return _electronicsCapacities
        .indexOf(_selectedSize)
        .clamp(0, _electronicsCapacities.length - 1);
  }

  int get _fragranceStepIndex {
    if (!_isFragrance) return 0;
    return _fragranceSizes
        .indexOf(_selectedSize)
        .clamp(0, _fragranceSizes.length - 1);
  }

  double get _weightIncreaseVnd {
    if (!_isWeightedGrocery) return 0;
    switch (_selectedSize) {
      case '2kg':
        return _vndStepByWeight2kg;
      case '5kg':
        return _vndStepByWeight5kg;
      default:
        return 0;
    }
  }

  double get _liquidIncreaseVnd {
    if (!_isLiquidProduct) return 0;
    if (_selectedSize == '1 lít') return 0;
    return _vndStepByLiquidSize;
  }

  double get _eggIncreaseVnd {
    if (!_isEggProduct) return 0;
    switch (_selectedSize) {
      case '20 quả':
        return _vndStepByEgg20;
      case '50 quả':
        return _vndStepByEgg50;
      default:
        return 0;
    }
  }

  double get _skinCareIncreaseVnd {
    if (!_isSkinCare) return 0;
    switch (_selectedSize) {
      case '200ml':
        return _vndStepBySkinCare200;
      case '500ml':
        return _vndStepBySkinCare500;
      default:
        return 0;
    }
  }

  double get _effectivePrice {
    if ((!_isElectronics || _isMobileAccessory) &&
        !_isFragrance &&
        !_isSkinCare &&
        !_isWeightedGrocery &&
        !_isLiquidProduct &&
        !_isEggProduct) {
      return widget.product.price;
    }
    final capacityIncreaseUsd =
        (_capacityStepIndex * _vndStepByCapacity) / _vndPerUsd;
    final fragranceIncreaseUsd =
        (_fragranceStepIndex * _vndStepByFragranceSize) / _vndPerUsd;
    final weightIncreaseUsd = _weightIncreaseVnd / _vndPerUsd;
    final liquidIncreaseUsd = _liquidIncreaseVnd / _vndPerUsd;
    final eggIncreaseUsd = _eggIncreaseVnd / _vndPerUsd;
    final skinCareIncreaseUsd = _skinCareIncreaseVnd / _vndPerUsd;
    final increaseUsd =
        capacityIncreaseUsd +
        fragranceIncreaseUsd +
        skinCareIncreaseUsd +
        weightIncreaseUsd +
        liquidIncreaseUsd +
        eggIncreaseUsd;
    return widget.product.price + increaseUsd;
  }

  String get _displayTitle {
    return localizedProductTitle(widget.product);
  }

  String get _displayPrice => Formatters.vnd(_effectivePrice);

  @override
  void initState() {
    super.initState();
    _selectedSize = (_isQuantityOnlyProduct || _isMotorcycle || _isWomensBag)
        ? 'none'
        : _sizes.first;
    _selectedColor =
        (_isQuantityOnlyProduct ||
            (_isElectronics && !_isSmartphone) ||
            _isFragrance ||
            _isSkinCare ||
            _isWeightedGrocery ||
            _isLiquidProduct ||
            _isEggProduct)
        ? 'none'
        : _colors.first['value'] as String;
  }

  @override
  Widget build(BuildContext context) {
    final product = widget.product;
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom + 24,
        left: 16,
        right: 16,
        top: 16,
      ),
      child: SafeArea(
        top: false,
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Handle bar
            Center(
              child: Container(
                width: 40,
                height: 4,
                decoration: BoxDecoration(
                  color: Colors.grey.shade300,
                  borderRadius: BorderRadius.circular(2),
                ),
              ),
            ),
            const SizedBox(height: 16),
            // Product preview
            Row(
              children: [
                ClipRRect(
                  borderRadius: BorderRadius.circular(8),
                  child: Hero(
                    tag: 'product_${product.id}_sheet',
                    child: Image.network(
                      product.image,
                      width: 80,
                      height: 80,
                      fit: BoxFit.cover,
                      errorBuilder: (_, _, _) =>
                          Container(width: 80, height: 80, color: Colors.grey),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        _displayTitle,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(fontWeight: FontWeight.w600),
                      ),
                      const SizedBox(height: 6),
                      Text(
                        _displayPrice,
                        style: const TextStyle(
                          color: Color(0xFFEE4D2D),
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
            if (!_isQuantityOnlyProduct && !_isMotorcycle && !_isWomensBag) ...[
              const SizedBox(height: 20),
              // Size selector
              Text(
                _isEggProduct
                    ? 'Chọn số lượng'
                    : _isWeightedGrocery
                    ? 'Chọn khối lượng'
                    : (_isElectronics ||
                              _isFragrance ||
                              _isSkinCare ||
                              _isLiquidProduct
                          ? 'Chọn dung tích'
                          : 'Chọn Kích cỡ'),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _sizes.map((size) {
                  final selected = size == _selectedSize;
                  return GestureDetector(
                    onTap: () => setState(() => _selectedSize = size),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 16,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: selected
                            ? const Color(0xFFEE4D2D)
                            : Colors.transparent,
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFEE4D2D)
                              : Colors.grey.shade400,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Text(
                        size,
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black87,
                          fontWeight: selected
                              ? FontWeight.bold
                              : FontWeight.normal,
                        ),
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            if (_isQuantityOnlyProduct ||
                (_isElectronics && !_isSmartphone) ||
                _isFragrance ||
                _isSkinCare ||
                _isWeightedGrocery ||
                _isLiquidProduct ||
                _isEggProduct)
              ...[]
            else ...[
              const SizedBox(height: 16),
              // Color selector
              const Text(
                'Chọn Màu sắc',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: _colors.map((c) {
                  final selected = c['value'] == _selectedColor;
                  return GestureDetector(
                    onTap: () =>
                        setState(() => _selectedColor = c['value'] as String),
                    child: AnimatedContainer(
                      duration: const Duration(milliseconds: 150),
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: selected
                              ? const Color(0xFFEE4D2D)
                              : Colors.grey.shade400,
                          width: selected ? 2 : 1,
                        ),
                        borderRadius: BorderRadius.circular(6),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Container(
                            width: 14,
                            height: 14,
                            decoration: BoxDecoration(
                              color: c['color'] as Color,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.grey.shade300),
                            ),
                          ),
                          const SizedBox(width: 6),
                          Text(c['label'] as String),
                        ],
                      ),
                    ),
                  );
                }).toList(),
              ),
            ],
            const SizedBox(height: 16),
            // Quantity selector
            Row(
              children: [
                const Text(
                  'Số lượng',
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                const Spacer(),
                _QuantityButton(
                  icon: Icons.remove,
                  onTap: _quantity > 1
                      ? () => setState(() => _quantity--)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  child: Text(
                    '$_quantity',
                    style: const TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                _QuantityButton(
                  icon: Icons.add,
                  onTap: () => setState(() => _quantity++),
                ),
              ],
            ),
            const SizedBox(height: 24),
            // Confirm button
            SizedBox(
              width: double.infinity,
              height: 48,
              child: ElevatedButton(
                onPressed: _confirm,
                style: ElevatedButton.styleFrom(
                  backgroundColor: const Color(0xFFEE4D2D),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: Text(
                  widget.buyNow ? 'Mua ngay' : 'Thêm vào giỏ hàng',
                  style: const TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _confirm() {
    final hasVariablePrice =
        _isElectronics ||
        _isFragrance ||
        _isSkinCare ||
        _isWeightedGrocery ||
        _isLiquidProduct ||
        _isEggProduct;

    final productForCart = hasVariablePrice
        ? Product(
            id: widget.product.id,
            title: localizedProductTitle(widget.product),
            price: _effectivePrice,
            description: widget.product.description,
            category: widget.product.category,
            image: widget.product.image,
            rating: widget.product.rating,
            ratingCount: widget.product.ratingCount,
            discountPercent: widget.product.discountPercent,
          )
        : widget.product;

    final cartItem = CartItem(
      product: productForCart,
      size: _selectedSize,
      color: _selectedColor,
      quantity: _quantity,
    );

    if (widget.buyNow) {
      // Đóng bottom sheet
      Navigator.pop(context);
      // Chuyển tới CheckoutScreen và truyền sản phẩm
      Navigator.pushNamed(context, '/checkout', arguments: [cartItem]);
    } else {
      // Thêm vào giỏ hàng
      context.read<CartProvider>().addItem(
        product: productForCart,
        size: _selectedSize,
        color: _selectedColor,
        quantity: _quantity,
      );
      Navigator.pop(context);
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('✓ Đã thêm vào giỏ hàng thành công!'),
          backgroundColor: Color(0xFF2E7D32),
          duration: Duration(seconds: 2),
        ),
      );
    }
  }

  // void _confirm() {
  //   final productForCart = _isElectronics
  //       ? Product(
  //           id: widget.product.id,
  //           title: widget.product.title,
  //           price: _effectivePrice,
  //           description: widget.product.description,
  //           category: widget.product.category,
  //           image: widget.product.image,
  //           rating: widget.product.rating,
  //           ratingCount: widget.product.ratingCount,
  //         )
  //       : widget.product;

  //   context.read<CartProvider>().addItem(
  //     product: productForCart,
  //     size: _selectedSize,
  //     color: _selectedColor,
  //     quantity: _quantity,
  //   );
  //   Navigator.pop(context);
  //   ScaffoldMessenger.of(context).showSnackBar(
  //     const SnackBar(
  //       content: Text('✓ Đã thêm vào giỏ hàng thành công!'),
  //       backgroundColor: Color(0xFF2E7D32),
  //       duration: Duration(seconds: 2),
  //     ),
  //   );
  //   if (widget.buyNow) {
  //     Navigator.pushNamed(context, '/cart');
  //   }
  // }
}

class _QuantityButton extends StatelessWidget {
  final IconData icon;
  final VoidCallback? onTap;

  const _QuantityButton({required this.icon, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 32,
        height: 32,
        decoration: BoxDecoration(
          border: Border.all(
            color: onTap != null ? Colors.grey.shade400 : Colors.grey.shade200,
          ),
          borderRadius: BorderRadius.circular(6),
        ),
        child: Icon(
          icon,
          size: 18,
          color: onTap != null ? Colors.black87 : Colors.grey.shade300,
        ),
      ),
    );
  }
}
