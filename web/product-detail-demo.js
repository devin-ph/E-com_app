const products = [
  {
    id: 1,
    name: "Nhẫn kim cương thanh lịch",
    category: "jewelery",
    price: 1299000,
    image: "https://fakestoreapi.com/img/71yaVmFohgL._AC_UL640_QL65_ML3_.jpg",
    description:
      "Nhẫn thiết kế tối giản, đính đá nhỏ tinh tế, phù hợp đi làm hoặc dự tiệc.",
    specs: {
      "Chất liệu": "Bạc 925",
      "Màu sắc": "Bạc",
      "Bảo hành": "12 tháng",
    },
  },
  {
    id: 2,
    name: "Áo khoác nam Urban Fit",
    category: "men's clothing",
    price: 699000,
    image: "https://fakestoreapi.com/img/71li-ujtlUL._AC_UX679_.jpg",
    description:
      "Áo khoác dáng regular, vải nhẹ, giữ ấm vừa đủ, dễ phối với quần jean hoặc kaki.",
    specs: {
      "Chất liệu": "Poly cotton",
      "Kích cỡ": "M, L, XL",
      "Xuất xứ": "Việt Nam",
    },
  },
  {
    id: 3,
    name: "Tai nghe Bluetooth True Wireless",
    category: "electronics",
    price: 1590000,
    image: "https://fakestoreapi.com/img/61IBBVJvSDL._AC_SY879_.jpg",
    description:
      "Tai nghe chống ồn cơ bản, pin dùng cả ngày, kết nối ổn định cho học tập và giải trí.",
    specs: {
      "Kết nối": "Bluetooth 5.3",
      "Thời lượng pin": "30 giờ",
      "Bảo hành": "18 tháng",
    },
  },
  {
    id: 4,
    name: "Serum dưỡng ẩm phục hồi da",
    category: "beauty",
    price: 420000,
    image:
      "https://images.unsplash.com/photo-1556228720-195a672e8a03?auto=format&fit=crop&w=1200&q=60",
    description:
      "Serum cấp ẩm nhanh, hỗ trợ làm dịu da, phù hợp nhiều loại da sử dụng hằng ngày.",
    specs: {
      "Dung tích": "30ml",
      "Hạn sử dụng": "24 tháng",
      "Loại da": "Mọi loại da",
    },
  },
];

const nodes = {
  list: document.getElementById("productList"),
  image: document.getElementById("detailImage"),
  name: document.getElementById("detailName"),
  price: document.getElementById("detailPrice"),
  category: document.getElementById("detailCategory"),
  description: document.getElementById("detailDescription"),
  specs: document.getElementById("detailSpecs"),
};

function formatCurrency(vnd) {
  return new Intl.NumberFormat("vi-VN", {
    style: "currency",
    currency: "VND",
    maximumFractionDigits: 0,
  }).format(vnd);
}

function categoryToVi(category) {
  const map = {
    jewelery: "Trang sức",
    "men's clothing": "Quần áo nam",
    "women's clothing": "Quần áo nữ",
    electronics: "Đồ điện tử",
    beauty: "Mỹ phẩm",
  };
  return map[category] ?? category;
}

function renderProductDetail(product) {
  nodes.image.src = product.image;
  nodes.image.alt = product.name;
  nodes.name.textContent = product.name;
  nodes.price.textContent = formatCurrency(product.price);
  nodes.category.textContent = `Danh mục: ${categoryToVi(product.category)}`;
  nodes.description.textContent = product.description;

  nodes.specs.innerHTML = "";
  Object.entries(product.specs).forEach(([key, value]) => {
    const li = document.createElement("li");
    li.textContent = `${key}: ${value}`;
    nodes.specs.appendChild(li);
  });
}

function renderProductList(items) {
  nodes.list.innerHTML = "";

  items.forEach((product, index) => {
    const card = document.createElement("button");
    card.type = "button";
    card.className = "product-item";
    card.innerHTML = `
      <p class="product-title">${product.name}</p>
      <p class="product-meta">${categoryToVi(product.category)} • ${formatCurrency(product.price)}</p>
    `;

    card.addEventListener("click", () => {
      document
        .querySelectorAll(".product-item")
        .forEach((item) => item.classList.remove("active"));
      card.classList.add("active");
      renderProductDetail(product);
    });

    if (index === 0) {
      card.classList.add("active");
      renderProductDetail(product);
    }

    nodes.list.appendChild(card);
  });
}

renderProductList(products);
