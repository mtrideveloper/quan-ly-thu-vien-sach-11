-- Tác giả
CREATE TABLE TacGia (
  tacgia_id         INT PRIMARY KEY AUTO_INCREMENT,
  ho_ten            VARCHAR(100),
  ngay_sinh         DATE,
  tieu_su           TEXT
);

-- Nhà xuất bản
CREATE TABLE NhaXuatBan (
  nxb_id            INT PRIMARY KEY AUTO_INCREMENT,
  ten               VARCHAR(255) NOT NULL,
  dia_chi           VARCHAR(255),
  so_dien_thoai     VARCHAR(50)
);

-- Thể loại sách
CREATE TABLE TheLoai (
  theloai_id        INT PRIMARY KEY AUTO_INCREMENT,
  ten_theloai       VARCHAR(100) NOT NULL UNIQUE
);

-- Sách
CREATE TABLE Sach (
  sach_id           INT PRIMARY KEY AUTO_INCREMENT,
  tieu_de           VARCHAR(255) NOT NULL,
  nxb_id            INT,
  theloai_id        INT,
  isbn              VARCHAR(20) UNIQUE,
  nam_xuat_ban      YEAR,
  tom_tat           TEXT,
  so_luong          INT DEFAULT 0,
  FOREIGN KEY (nxb_id) REFERENCES NhaXuatBan(nxb_id),
  FOREIGN KEY (theloai_id) REFERENCES TheLoai(theloai_id)
);

-- Nếu 1 cuốn sách có nhiều tác giả
CREATE TABLE Sach_TacGia (
  sach_id           INT,
  tacgia_id         INT,
  PRIMARY KEY (sach_id, tacgia_id),
  FOREIGN KEY (sach_id) REFERENCES Sach(sach_id),
  FOREIGN KEY (tacgia_id) REFERENCES TacGia(tacgia_id)
);

-- Bản sao sách (copy)
CREATE TABLE BanSaoSach (
  bansao_id         INT PRIMARY KEY AUTO_INCREMENT,
  sach_id           INT NOT NULL,
  ma_vach           VARCHAR(100) UNIQUE NOT NULL,
  trang_thai        ENUM('con_sach','dang_muon','mat','sua_chua') DEFAULT 'con_sach',
  FOREIGN KEY (sach_id) REFERENCES Sach(sach_id)
);

-- Thành viên thư viện
CREATE TABLE ThanhVien (
  thanhvien_id      INT PRIMARY KEY AUTO_INCREMENT,
  ho_ten            VARCHAR(100),
  email             VARCHAR(255) UNIQUE NOT NULL,
  so_dien_thoai     VARCHAR(50),
  dia_chi           VARCHAR(255),
  ngay_tham_gia     DATE NOT NULL,
  trang_thai        ENUM('hoat_dong','tam_ngung','het_han') DEFAULT 'hoat_dong'
);

-- Nhân viên thư viện
CREATE TABLE NhanVien (
  nhanvien_id       INT PRIMARY KEY AUTO_INCREMENT,
  ho_ten            VARCHAR(100),
  email             VARCHAR(255) UNIQUE NOT NULL,
  so_dien_thoai     VARCHAR(50),
  vai_tro           VARCHAR(50)
);

-- Phiếu mượn
CREATE TABLE PhieuMuon (
  phieumuon_id      INT PRIMARY KEY AUTO_INCREMENT,
  bansao_id         INT NOT NULL,
  thanhvien_id      INT NOT NULL,
  nhanvien_id       INT,              
  ngay_muon         DATE NOT NULL,
  han_tra           DATE NOT NULL,
  ngay_tra          DATE,
  FOREIGN KEY (bansao_id) REFERENCES BanSaoSach(bansao_id),
  FOREIGN KEY (thanhvien_id) REFERENCES ThanhVien(thanhvien_id),
  FOREIGN KEY (nhanvien_id) REFERENCES NhanVien(nhanvien_id)
);

-- Phiếu phạt
CREATE TABLE PhieuPhat (
  phieuphat_id      INT PRIMARY KEY AUTO_INCREMENT,
  phieumuon_id      INT NOT NULL,
  so_tien           DECIMAL(10,2) NOT NULL,
  da_tra            BOOLEAN DEFAULT FALSE,
  ngay_xu_phat      DATE NOT NULL,
  ngay_dong_phat    DATE,
  FOREIGN KEY (phieumuon_id) REFERENCES PhieuMuon(phieumuon_id)
);
