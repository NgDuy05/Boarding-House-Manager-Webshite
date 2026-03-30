# Tài Liệu Hướng Dẫn Sử Dụng Hệ Thống Quản Lý Nhà Trọ

**Tên dự án:** Boarding House Management Website
**Phiên bản:** 1.0
**Ngày lập:** 25/03/2026
**Nhóm thực hiện:** [Tên nhóm]
**Giảng viên hướng dẫn:** [Tên giảng viên]

---

## Mục Lục

1. [Giới Thiệu Hệ Thống](#1-giới-thiệu-hệ-thống)
2. [Yêu Cầu Hệ Thống](#2-yêu-cầu-hệ-thống)
3. [Hướng Dẫn Cài Đặt](#3-hướng-dẫn-cài-đặt)
4. [Kiến Trúc Hệ Thống](#4-kiến-trúc-hệ-thống)
5. [Phân Quyền Người Dùng](#5-phân-quyền-người-dùng)
6. [Hướng Dẫn Sử Dụng - Trang Khách](#6-hướng-dẫn-sử-dụng---trang-khách)
7. [Hướng Dẫn Sử Dụng - Người Thuê](#7-hướng-dẫn-sử-dụng---người-thuê)
8. [Hướng Dẫn Sử Dụng - Quản Trị Viên](#8-hướng-dẫn-sử-dụng---quản-trị-viên)
9. [Sơ Đồ Cơ Sở Dữ Liệu](#9-sơ-đồ-cơ-sở-dữ-liệu)
10. [Xử Lý Sự Cố Thường Gặp](#10-xử-lý-sự-cố-thường-gặp)

---

## 1. Giới Thiệu Hệ Thống

### 1.1 Tổng Quan

Hệ thống Quản Lý Nhà Trọ (Boarding House Management Website) là một ứng dụng web được xây dựng nhằm số hóa và tự động hóa các nghiệp vụ quản lý nhà trọ, bao gồm: quản lý phòng, hợp đồng thuê, hóa đơn, dịch vụ tiện ích, và thông báo giữa chủ trọ và người thuê.

Hệ thống được thiết kế phục vụ ba đối tượng người dùng chính:

- **Khách vãng lai (Guest):** Xem thông tin phòng trọ và các tiện ích mà không cần đăng nhập.
- **Người thuê (Customer):** Theo dõi hợp đồng, hóa đơn, gửi yêu cầu dịch vụ và nhận thông báo.
- **Quản trị viên (Admin):** Quản lý toàn bộ hệ thống bao gồm phòng, hợp đồng, người dùng, hóa đơn và báo cáo.

### 1.2 Các Chức Năng Chính

| STT | Chức Năng | Đối Tượng |
|-----|-----------|-----------|
| 1 | Quản lý tài khoản và xác thực | Tất cả |
| 2 | Xem danh sách và chi tiết phòng trọ | Tất cả |
| 3 | Quản lý hợp đồng thuê phòng | Admin, Customer |
| 4 | Quản lý hóa đơn và thanh toán | Admin, Customer |
| 5 | Quản lý tiện ích (điện, nước, gas) | Admin |
| 6 | Quản lý yêu cầu dịch vụ bảo trì | Admin, Customer |
| 7 | Hệ thống thông báo | Admin, Customer |
| 8 | Quản lý cọc/đặt cọc | Admin |
| 9 | Quản lý tiện nghi và cơ sở vật chất | Admin |
| 10 | Nhật ký hoạt động hệ thống | Admin |

---

## 2. Yêu Cầu Hệ Thống

### 2.1 Yêu Cầu Phần Cứng

| Thành Phần | Tối Thiểu | Khuyến Nghị |
|------------|-----------|-------------|
| CPU | 2 cores | 4 cores trở lên |
| RAM | 4 GB | 8 GB trở lên |
| Ổ đĩa | 10 GB | 20 GB trở lên |
| Mạng | 10 Mbps | 100 Mbps trở lên |

### 2.2 Yêu Cầu Phần Mềm

| Phần Mềm | Phiên Bản | Ghi Chú |
|----------|-----------|---------|
| Java Development Kit (JDK) | 11 | Bắt buộc |
| Apache Maven | 3.3.0 trở lên | Build tool |
| Jakarta EE Server (GlassFish / Tomcat 10+) | 9.1.0 | Application server |
| Microsoft SQL Server | 2019 trở lên | Database server |
| Trình duyệt web | Chrome / Firefox / Edge phiên bản mới nhất | Phía client |

---

## 3. Hướng Dẫn Cài Đặt

### 3.1 Cấu Hình Cơ Sở Dữ Liệu

1. Mở Microsoft SQL Server Management Studio (SSMS).
2. Tạo database mới với tên: `House_management_systemPrice_3`.
3. Chạy script SQL tạo bảng (đặt trong thư mục `database/` của dự án nếu có).
4. Mở file `src/main/java/dal/DBContext.java`, cập nhật thông tin kết nối:

```java
// Cấu hình kết nối cơ sở dữ liệu
private String url = "jdbc:sqlserver://localhost:1433;databaseName=House_management_systemPrice_3";
private String username = "<username_của_bạn>";
private String password = "<password_của_bạn>";
```

### 3.2 Build và Triển Khai

**Bước 1:** Clone hoặc giải nén mã nguồn dự án.

**Bước 2:** Mở terminal tại thư mục gốc dự án, chạy lệnh build:

```bash
mvn clean package
```

**Bước 3:** File WAR được tạo ra tại:

```
target/House_management-1.0-SNAPSHOT.war
```

**Bước 4:** Deploy file WAR lên application server (GlassFish hoặc Tomcat 10+).

**Bước 5:** Truy cập hệ thống qua trình duyệt tại địa chỉ:

```
http://localhost:8080/House_management-1.0-SNAPSHOT/home
```

---

## 4. Kiến Trúc Hệ Thống

### 4.1 Mô Hình Tổng Thể

Hệ thống được xây dựng theo mô hình **MVC (Model - View - Controller)** kết hợp **DAO Pattern**, triển khai trên nền tảng Jakarta EE.

```
+---------------------------+
|    Trình duyệt (Client)   |
+---------------------------+
             |  HTTP Request/Response
+---------------------------+
|   View Layer (JSP / HTML) |  84 trang JSP
+---------------------------+
             |  Forward / Redirect
+---------------------------+
| Controller (Servlet)      |  18 Servlet
+---------------------------+
             |  Gọi DAO
+---------------------------+
| DAO Layer                 |  12 DAO class
+---------------------------+
             |  JDBC
+---------------------------+
| Database (MS SQL Server)  |
+---------------------------+
```

### 4.2 Thành Phần Hệ Thống

| Lớp | Công Nghệ | Mô Tả |
|-----|-----------|-------|
| View | JSP, HTML, Bootstrap 5 | Giao diện người dùng |
| Controller | Jakarta Servlet | Xử lý request, điều hướng luồng |
| Model | Java POJO | Đối tượng dữ liệu (23 class) |
| DAO | JDBC, PreparedStatement | Truy xuất dữ liệu |
| Filter | LoginFilter | Xác thực phiên và phân quyền |
| Database | Microsoft SQL Server | Lưu trữ dữ liệu |

---

## 5. Phân Quyền Người Dùng

### 5.1 Sơ Đồ Phân Quyền

Hệ thống có ba cấp độ truy cập:

```
+-------------------+          +-------------------+          +-------------------+
|   Khách vãng lai  |          |   Người Thuê       |          |  Quản Trị Viên    |
|    (Guest)        |          |   (Customer)       |          |    (Admin)        |
+-------------------+          +-------------------+          +-------------------+
| - Xem trang chủ  |          | - Tất cả của Guest |          | - Tất cả           |
| - Xem danh sách  |          | - Dashboard        |          | - CRUD toàn bộ    |
|   phòng          |          | - Hợp đồng         |          |   dữ liệu         |
| - Xem tiện nghi  |          | - Hóa đơn          |          | - Quản lý người   |
| - Đăng ký        |          | - Dịch vụ          |          |   dùng            |
| - Đăng nhập      |          | - Thông báo        |          | - Nhật ký HĐ      |
|                  |          | - Hồ sơ cá nhân    |          | - Báo cáo         |
+-------------------+          +-------------------+          +-------------------+
```

### 5.2 Bảng URL Theo Quyền

| Đường Dẫn | Khách | Customer | Admin |
|-----------|-------|----------|-------|
| `/home` | Có | Có | Có |
| `/auth` (login/register) | Có | - | - |
| `/customer/*` | - | Có | - |
| `/admin/*` | - | - | Có |
| `/room*` | Có | Có | Có |
| `/contract` | - | Xem | CRUD |
| `/bill` | - | Xem | CRUD |
| `/service*` | - | Có | Có |
| `/notification` | - | Có | Có |
| `/user*` | - | - | Có |
| `/utility/*` | - | - | Có |
| `/deposit/*` | - | - | Có |
| `/price/*` | - | - | Có |
| `/activity-log` | - | - | Có |

---

## 6. Hướng Dẫn Sử Dụng - Trang Khách

### 6.1 Trang Chủ

Khi truy cập vào địa chỉ hệ thống, người dùng được chuyển tới trang chủ (`/home`). Tại đây hiển thị:

- Giới thiệu tổng quan về nhà trọ
- Danh sách phòng nổi bật
- Các tiện ích chung của khu nhà

### 6.2 Xem Danh Sách Phòng

1. Nhấn vào menu **"Phòng"** hoặc truy cập `/rooms`.
2. Hệ thống hiển thị danh sách phòng với thông tin: số phòng, loại phòng, trạng thái, giá cơ bản.
3. Nhấn vào **"Xem chi tiết"** để xem đầy đủ thông tin phòng, tiện nghi đi kèm.

**Trạng thái phòng:**
- `Còn trống (Available)`: Phòng sẵn sàng cho thuê.
- `Đang sử dụng (Occupied)`: Phòng đã có người ở.
- `Đang bảo trì (Maintenance)`: Phòng tạm thời không cho thuê.

### 6.3 Đăng Ký Tài Khoản

1. Truy cập `/auth` hoặc nhấn **"Đăng ký"** trên thanh điều hướng.
2. Điền đầy đủ thông tin:
   - Tên đăng nhập (username)
   - Mật khẩu (tối thiểu 6 ký tự)
   - Họ và tên đầy đủ
   - Email
   - Số điện thoại
3. Nhấn **"Đăng ký"** để hoàn tất.

### 6.4 Đăng Nhập

1. Truy cập `/auth` hoặc nhấn **"Đăng nhập"**.
2. Nhập tên đăng nhập và mật khẩu.
3. Nhấn **"Đăng nhập"**.
4. Hệ thống tự động chuyển hướng theo vai trò: Admin → `/admin/dashboard`, Customer → `/customer/dashboard`.

### 6.5 Quên Mật Khẩu

1. Nhấn **"Quên mật khẩu"** tại trang đăng nhập.
2. Nhập email đã đăng ký.
3. Hệ thống gửi email chứa OTP xác nhận.
4. Nhập OTP và đặt lại mật khẩu mới.

---

## 7. Hướng Dẫn Sử Dụng - Người Thuê

### 7.1 Dashboard Người Thuê

Sau khi đăng nhập, người thuê được chuyển tới Dashboard (`/customer/dashboard`) hiển thị:

- Thông tin tóm tắt hợp đồng hiện tại
- Hóa đơn cần thanh toán
- Thông báo mới nhất
- Các yêu cầu dịch vụ đang xử lý

### 7.2 Xem Hợp Đồng

1. Chọn **"Hợp đồng"** từ menu điều hướng.
2. Danh sách hợp đồng hiển thị với trạng thái:
   - `Đang hiệu lực (Active)`: Hợp đồng đang trong thời hạn.
   - `Hết hạn (Expired)`: Hợp đồng đã quá ngày kết thúc.
   - `Đã chấm dứt (Terminated)`: Hợp đồng bị hủy trước thời hạn.
3. Nhấn **"Chi tiết"** để xem đầy đủ thông tin hợp đồng, danh sách người cùng thuê.

### 7.3 Xem và Tra Cứu Hóa Đơn

1. Chọn **"Hóa đơn"** từ menu.
2. Danh sách hóa đơn hiển thị theo tháng với trạng thái:
   - `Chưa thanh toán (Pending)`: Hóa đơn chờ thanh toán.
   - `Đã thanh toán (Paid)`: Hóa đơn đã hoàn tất.
   - `Quá hạn (Overdue)`: Hóa đơn đã qua ngày đáo hạn.
3. Nhấn **"Chi tiết"** để xem các khoản mục chi tiết (tiền phòng, điện, nước, dịch vụ, ...).

### 7.4 Gửi Yêu Cầu Dịch Vụ

1. Chọn **"Dịch vụ"** từ menu.
2. Xem danh sách dịch vụ hiện có (bảo trì, sửa chữa, ...).
3. Nhấn **"Yêu cầu dịch vụ"** và điền mô tả vấn đề.
4. Nhấn **"Gửi"** để gửi yêu cầu tới quản trị viên.
5. Theo dõi trạng thái xử lý tại mục **"Lịch sử yêu cầu"**.

### 7.5 Xem Thông Báo

1. Chọn **"Thông báo"** từ menu.
2. Hệ thống hiển thị hai loại thông báo:
   - **Thông báo chung (Chung):** Gửi đến tất cả người thuê.
   - **Thông báo riêng (Riêng):** Gửi đến hợp đồng/phòng cụ thể.
3. Nhấn vào thông báo để xem nội dung đầy đủ.

### 7.6 Quản Lý Hồ Sơ Cá Nhân

1. Nhấn vào tên người dùng ở góc trên bên phải.
2. Chọn **"Hồ sơ"** để xem và cập nhật thông tin:
   - Họ tên, email, số điện thoại, ảnh đại diện
3. Chọn **"Đổi mật khẩu"** để thay đổi mật khẩu đăng nhập.

---

## 8. Hướng Dẫn Sử Dụng - Quản Trị Viên

### 8.1 Dashboard Quản Trị

Trang Dashboard (`/admin/dashboard`) cung cấp cái nhìn tổng quan về:

- Tổng số phòng, phòng còn trống, phòng đang cho thuê
- Tổng số hợp đồng đang hiệu lực
- Hóa đơn chưa thanh toán/quá hạn
- Yêu cầu dịch vụ đang chờ xử lý
- Thông báo hoạt động gần đây

### 8.2 Quản Lý Phòng

**Truy cập:** Menu `Phòng` > `Danh sách phòng`

#### 8.2.1 Thêm Phòng Mới

1. Nhấn **"Thêm phòng"**.
2. Điền thông tin:
   - Số phòng
   - Loại phòng (chọn từ danh mục đã tạo)
   - Trạng thái (Còn trống / Đang sử dụng / Bảo trì)
   - Tải ảnh phòng (tùy chọn)
3. Nhấn **"Lưu"**.

#### 8.2.2 Chỉnh Sửa Thông Tin Phòng

1. Nhấn icon chỉnh sửa trên dòng phòng cần sửa.
2. Cập nhật thông tin cần thiết.
3. Nhấn **"Cập nhật"**.

#### 8.2.3 Quản Lý Danh Mục Phòng

Danh mục phòng định nghĩa loại phòng (Standard, Deluxe, Suite, ...) và giá cơ bản tương ứng.

1. Vào menu `Phòng` > `Danh mục phòng`.
2. Thêm/sửa/xóa danh mục với: Tên danh mục, Giá cơ bản.

### 8.3 Quản Lý Hợp Đồng

**Truy cập:** Menu `Hợp đồng`

#### 8.3.1 Tạo Hợp Đồng Mới

1. Nhấn **"Thêm hợp đồng"**.
2. Điền thông tin hợp đồng:
   - Chọn phòng
   - Chọn khách thuê (người dùng trong hệ thống)
   - Ngày bắt đầu, ngày kết thúc
   - Tổng giá
3. Nhấn **"Lưu"**.

#### 8.3.2 Quản Lý Người Cùng Thuê (Tenant)

Mỗi hợp đồng có thể có nhiều người cùng thuê (co-tenants):

1. Mở chi tiết hợp đồng.
2. Chọn **"Quản lý người thuê"**.
3. Thêm người thuê với thông tin: Họ tên, số điện thoại, số CCCD, ngày sinh.
4. Đánh dấu **"Người đại diện chính"** cho người thuê chính.

#### 8.3.3 Lịch Sử Người Thuê Theo Phòng

Từ trang chi tiết phòng, admin có thể xem toàn bộ lịch sử các hợp đồng và người từng thuê phòng đó.

### 8.4 Quản Lý Hóa Đơn

**Truy cập:** Menu `Hóa đơn`

#### 8.4.1 Tạo Hóa Đơn

1. Nhấn **"Tạo hóa đơn"**.
2. Chọn hợp đồng.
3. Thêm các khoản mục (bill items): mô tả, số lượng, đơn giá.
4. Đặt ngày đáo hạn thanh toán.
5. Nhấn **"Lưu"**.

Hệ thống hỗ trợ tạo hóa đơn hàng loạt cho nhiều hợp đồng cùng lúc.

#### 8.4.2 Cập Nhật Trạng Thái Hóa Đơn

1. Mở chi tiết hóa đơn.
2. Chọn **"Cập nhật trạng thái"**: Pending / Paid / Overdue.
3. Nhấn **"Lưu"**.

### 8.5 Quản Lý Tiện Ích

**Truy cập:** Menu `Tiện ích`

Hệ thống quản lý ba loại tiện ích: **Điện, Nước, Gas**

#### 8.5.1 Ghi Chỉ Số Đồng Hồ

1. Chọn tiện ích cần ghi.
2. Nhấn **"Thêm chỉ số"**.
3. Nhập chỉ số mới, ngày đọc.
4. Hệ thống tự tính lượng tiêu thụ và chi phí dựa trên bảng giá hiện tại.

#### 8.5.2 Cập Nhật Bảng Giá Tiện Ích

1. Chọn loại tiện ích.
2. Nhấn **"Cập nhật giá"**.
3. Nhập đơn giá mới và ngày áp dụng.
4. Hệ thống lưu lịch sử thay đổi giá để đảm bảo tính minh bạch.

### 8.6 Quản Lý Đặt Cọc

**Truy cập:** Menu `Đặt cọc`

1. Nhấn **"Thêm giao dịch cọc"**.
2. Chọn hợp đồng.
3. Chọn loại giao dịch: **Đặt cọc (Deposit)** hoặc **Hoàn cọc (Refund)**.
4. Nhập số tiền và ngày giao dịch.
5. Nhấn **"Lưu"**.

### 8.7 Quản Lý Thông Báo

**Truy cập:** Menu `Thông báo`

#### 8.7.1 Gửi Thông Báo Chung

1. Nhấn **"Tạo thông báo"**.
2. Nhập tiêu đề và nội dung.
3. Để trống trường **"Hợp đồng"** để gửi tới tất cả.
4. Nhấn **"Gửi"**.

#### 8.7.2 Gửi Thông Báo Riêng

1. Nhấn **"Tạo thông báo"**.
2. Nhập tiêu đề và nội dung.
3. Chọn **hợp đồng cụ thể** cần nhận thông báo.
4. Nhấn **"Gửi"**.

### 8.8 Quản Lý Tiện Nghi và Cơ Sở Vật Chất

**Tiện nghi (Amenity):** WiFi, bãi đỗ xe, phòng gym, ...
**Cơ sở vật chất (Facility):** Thang máy, camera an ninh, ...

Quy trình quản lý tương tự:
1. Vào menu `Tiện nghi` hoặc `Cơ sở vật chất`.
2. Nhấn **"Thêm mới"**, điền tên và mô tả.
3. Phân bổ tiện nghi/cơ sở vật chất vào phòng cụ thể thông qua trang chi tiết phòng.

### 8.9 Quản Lý Người Dùng

**Truy cập:** Menu `Người dùng`

1. Xem danh sách tất cả người dùng trong hệ thống.
2. Nhấn **"Chỉnh sửa"** để cập nhật thông tin: tên, email, số điện thoại, ảnh đại diện.
3. Sử dụng chức năng **"Vô hiệu hóa"** để tạm khóa tài khoản (soft delete - dữ liệu không bị xóa).

### 8.10 Nhật Ký Hoạt Động

**Truy cập:** Menu `Nhật ký`

Hệ thống tự động ghi lại mọi hành động của quản trị viên. Nhật ký bao gồm:
- Người thực hiện
- Hành động (thêm/sửa/xóa)
- Đối tượng bị tác động
- Thời gian thực hiện

Đây là công cụ quan trọng để kiểm tra, giám sát và đảm bảo tính minh bạch trong quản lý.

---

## 9. Sơ Đồ Cơ Sở Dữ Liệu

### 9.1 Các Bảng Chính

| Tên Bảng | Mô Tả | Các Cột Chính |
|----------|-------|---------------|
| `user` | Tài khoản người dùng | userId, userName, password, fullName, email, phone, role, isDeleted |
| `room` | Danh sách phòng | roomId, roomNumber, categoryId, status, image, isDeleted |
| `room_category` | Danh mục phòng | categoryId, categoryName, basePrice |
| `contract` | Hợp đồng thuê | contractId, roomId, startDate, endDate, totalPrice, status, isDeleted |
| `contract_tenant` | Người cùng thuê | tenantId, contractId, fullName, phone, cccd, birthDate, isPrimary |
| `contract_user` | Liên kết hợp đồng - người dùng | contractId, userId |
| `bill` | Hóa đơn | billId, contractId, totalAmount, status, createdDate, dueDate |
| `bill_item` | Chi tiết khoản mục hóa đơn | billItemId, billId, description, quantity, unitPrice, amount |
| `deposit_transaction` | Giao dịch đặt cọc | transactionId, contractId, amount, type, date |
| `service` | Danh mục dịch vụ | serviceId, serviceName, description, price |
| `service_usage` | Yêu cầu sử dụng dịch vụ | usageId, contractId, serviceId, requestDate, status |
| `notification` | Thông báo | notificationId, title, content, targetContractId, createdDate |
| `utility` | Loại tiện ích | utilityId, utilityName, unit |
| `utility_price` | Bảng giá tiện ích | priceId, utilityId, unitPrice, effectiveDate |
| `utility_usage` | Ghi nhận tiêu thụ | usageId, contractId, utilityId, meterReading, usageDate, amount |
| `amenity` | Tiện nghi | amenityId, amenityName |
| `facility` | Cơ sở vật chất | facilityId, facilityName |
| `room_amenity` | Phòng - Tiện nghi | roomId, amenityId |
| `room_facility` | Phòng - Cơ sở vật chất | roomId, facilityId |
| `price_category` | Danh mục giá | categoryId, categoryName, basePrice |
| `price_history` | Lịch sử thay đổi giá | historyId, categoryId, oldPrice, newPrice, changedDate |
| `activity_log` | Nhật ký hoạt động | logId, userId, action, description, timestamp |

### 9.2 Quan Hệ Giữa Các Bảng

- Một **phòng** có thể có nhiều **hợp đồng** qua các thời kỳ (1-N).
- Một **hợp đồng** có nhiều **người cùng thuê**, nhiều **hóa đơn**, nhiều **yêu cầu dịch vụ** (1-N).
- Một **tiện ích** có nhiều bản ghi **giá** (theo thời gian) và nhiều bản ghi **tiêu thụ** (1-N).
- Phòng và **tiện nghi/cơ sở vật chất** có quan hệ nhiều-nhiều (N-N) qua bảng trung gian.
- **Thông báo** với `targetContractId = NULL` là thông báo chung (broadcast), ngược lại là thông báo riêng.

---

## 10. Xử Lý Sự Cố Thường Gặp

### 10.1 Không Kết Nối Được Cơ Sở Dữ Liệu

**Triệu chứng:** Trang web hiển thị lỗi 500, không load được dữ liệu.

**Nguyên nhân và cách xử lý:**

| Nguyên Nhân | Cách Xử Lý |
|-------------|------------|
| SQL Server chưa được khởi động | Mở Services > Khởi động SQL Server |
| Sai thông tin kết nối | Kiểm tra `DBContext.java` (host, port, database name, username, password) |
| Firewall chặn port 1433 | Mở port 1433 trong Windows Firewall |
| Database chưa được tạo | Tạo database theo hướng dẫn mục 3.1 |

### 10.2 Không Đăng Nhập Được

**Triệu chứng:** Nhập đúng thông tin nhưng không vào được hệ thống.

**Cách xử lý:**
1. Kiểm tra tài khoản có bị vô hiệu hóa (`isDeleted = 1`) trong database.
2. Đảm bảo mật khẩu được lưu dưới dạng MD5 đúng cách.
3. Xóa cookie và session của trình duyệt rồi thử lại.

### 10.3 Lỗi Build Maven

**Triệu chứng:** Lệnh `mvn clean package` thất bại.

**Cách xử lý:**
1. Đảm bảo JDK 11 đã được cài đặt và `JAVA_HOME` được cấu hình.
2. Chạy `mvn dependency:resolve` để tải đầy đủ dependencies.
3. Kiểm tra kết nối internet nếu lần đầu build.

### 10.4 Phiên Đăng Nhập Bị Hết Hạn

**Triệu chứng:** Đang làm việc bị chuyển về trang đăng nhập.

**Giải thích:** Hệ thống tự động hết phiên sau **30 phút** không hoạt động (session timeout). Đây là tính năng bảo mật mặc định.

**Cách xử lý:** Đăng nhập lại và tiếp tục công việc.

---

*Tài liệu này được soạn thảo phục vụ mục đích hướng dẫn sử dụng và báo cáo học tập. Mọi thông tin kỹ thuật phản ánh trạng thái hệ thống tại thời điểm ngày 25/03/2026.*
