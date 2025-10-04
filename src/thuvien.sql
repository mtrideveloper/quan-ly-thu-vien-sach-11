-- Người dùng (gộp cả nhân viên & thành viên)
CREATE TABLE NguoiDung (
  nguoidung_id      VARCHAR(36) PRIMARY KEY,
  ho_ten            VARCHAR(100),
  email             VARCHAR(255) UNIQUE NOT NULL,
  password          VARCHAR(255) NOT NULL,
  so_dien_thoai     VARCHAR(50),
  dia_chi           VARCHAR(255),
  ngay_tham_gia     DATE,
  trang_thai        ENUM('hoat_dong','tam_ngung'),
  vai_tro           ENUM('thanh_vien','nhan_vien') NOT NULL
);

-- Tác giả
CREATE TABLE TacGia (
  tacgia_id         VARCHAR(36) PRIMARY KEY,
  ho_ten            VARCHAR(100),
  ngay_sinh         DATE,
  tieu_su           TEXT
);

-- Nhà xuất bản
CREATE TABLE NhaXuatBan (
  nxb_id            VARCHAR(36) PRIMARY KEY,
  ten               VARCHAR(255) NOT NULL,
  dia_chi           VARCHAR(255),
  so_dien_thoai     VARCHAR(50)
);

-- Thể loại sách
CREATE TABLE TheLoai (
  theloai_id        VARCHAR(36) PRIMARY KEY,
  ten_theloai       VARCHAR(100) NOT NULL UNIQUE
);

-- Sách
CREATE TABLE Sach (
  sach_id           VARCHAR(36) PRIMARY KEY,
  tieu_de           VARCHAR(255) NOT NULL,
  nxb_id            VARCHAR(36),
  theloai_id        VARCHAR(36),
  nguoidung_id      VARCHAR(36),
  isbn              VARCHAR(20) UNIQUE,
  nam_xuat_ban      YEAR,
  tom_tat           TEXT,
  so_luong          INT DEFAULT 0,
  FOREIGN KEY (nxb_id) REFERENCES NhaXuatBan(nxb_id),
  FOREIGN KEY (theloai_id) REFERENCES TheLoai(theloai_id),
  FOREIGN KEY (nguoidung_id) REFERENCES NguoiDung(nguoidung_id)
);

-- Nếu 1 cuốn sách có nhiều tác giả
CREATE TABLE Sach_TacGia (
  sach_id           VARCHAR(36),
  tacgia_id         VARCHAR(36),
  PRIMARY KEY (sach_id, tacgia_id),
  FOREIGN KEY (sach_id) REFERENCES Sach(sach_id),
  FOREIGN KEY (tacgia_id) REFERENCES TacGia(tacgia_id)
);

-- Bản sao sách (copy)
CREATE TABLE BanSaoSach (
  bansao_id         VARCHAR(36) PRIMARY KEY,
  sach_id           VARCHAR(36) NOT NULL,
  ma_vach           VARCHAR(100) UNIQUE NOT NULL,
  trang_thai        ENUM('da_muon','co_san', 'mat') DEFAULT 'co_san',
  FOREIGN KEY (sach_id) REFERENCES Sach(sach_id)
);

-- Phiếu mượn
CREATE TABLE PhieuMuon (
  phieumuon_id      VARCHAR(36) PRIMARY KEY,
  bansao_id         VARCHAR(36) NOT NULL,
  nguoidung_id      VARCHAR(36) NOT NULL,
  ngay_muon         DATE NOT NULL,
  han_tra           DATE NOT NULL,
  ngay_tra          DATE,
  FOREIGN KEY (bansao_id) REFERENCES BanSaoSach(bansao_id),
  FOREIGN KEY (nguoidung_id) REFERENCES NguoiDung(nguoidung_id)
);

-- Phiếu phạt
CREATE TABLE PhieuPhat (
  phieuphat_id      VARCHAR(36) PRIMARY KEY,
  phieumuon_id      VARCHAR(36) NOT NULL,
  so_tien           DECIMAL(10,2) NOT NULL,
  da_tra            BOOLEAN DEFAULT FALSE,
  ngay_xu_phat      DATE NOT NULL,
  ngay_dong_phat    DATE,
  FOREIGN KEY (phieumuon_id) REFERENCES PhieuMuon(phieumuon_id)
);
