# Feature File Map

## 1. Authentication

**Controllers**
- `src/main/java/Controllers/AuthServlet.java`

**Filter**
- `src/main/java/Filter/LoginFilter.java`

**DAL**
- `src/main/java/DALs/UserDAO.java`

**Models**
- `src/main/java/Models/User.java`

**Views**
- `src/main/webapp/views/login.jsp`
- `src/main/webapp/views/register.jsp`
- `src/main/webapp/views/forgetPassword.jsp`

---

## 2. User Management

**Controllers**
- `src/main/java/Controllers/UserServlet.java`

**DAL**
- `src/main/java/DALs/UserDAO.java`

**Models**
- `src/main/java/Models/User.java`

**Views (Admin)**
- `src/main/webapp/views/admin/users/users.jsp`
- `src/main/webapp/views/admin/users/editUser.jsp`

---

## 3. Customer Management

**Controllers**
- `src/main/java/Controllers/CustomerServlet.java`
- `src/main/java/Controllers/ManageCustomerServlet.java`

**DAL**
- `src/main/java/DALs/UserDAO.java`

**Models**
- `src/main/java/Models/User.java`
- `src/main/java/Models/ContractTenant.java`

**Views (Admin)**
- `src/main/webapp/views/admin/customers/customers.jsp`
- `src/main/webapp/views/admin/customers/createCustomer.jsp`
- `src/main/webapp/views/admin/customers/editCustomer.jsp`
- `src/main/webapp/views/admin/customers/customerDetail.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/profile.jsp`
- `src/main/webapp/views/customer/profileUpdate.jsp`
- `src/main/webapp/views/customer/changePassword.jsp`
- `src/main/webapp/views/customer/dashboard.jsp`

---

## 4. Room Management

**Controllers**
- `src/main/java/Controllers/RoomServlet.java`

**DAL**
- `src/main/java/DALs/RoomDAO.java`
- `src/main/java/DALs/RoomCategoryDAO.java`

**Models**
- `src/main/java/Models/Room.java`
- `src/main/java/Models/RoomCategory.java`
- `src/main/java/Models/RoomAmenity.java`
- `src/main/java/Models/RoomFacility.java`

**Views (Admin)**
- `src/main/webapp/views/admin/rooms/rooms.jsp`
- `src/main/webapp/views/admin/rooms/createRoom.jsp`
- `src/main/webapp/views/admin/rooms/editRoom.jsp`
- `src/main/webapp/views/admin/rooms/roomDetail.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/rooms.jsp`
- `src/main/webapp/views/customer/roomDetail.jsp`
- `src/main/webapp/views/customer/roomCategories.jsp`

---

## 5. Contract Management

**Controllers**
- `src/main/java/Controllers/ContractServlet.java`

**DAL**
- `src/main/java/DALs/ContractDAO.java`

**Models**
- `src/main/java/Models/Contract.java`
- `src/main/java/Models/ContractTenant.java`
- `src/main/java/Models/ContractUser.java`

**Views (Admin)**
- `src/main/webapp/views/admin/contracts/contracts.jsp`
- `src/main/webapp/views/admin/contracts/createContract.jsp`
- `src/main/webapp/views/admin/contracts/editContract.jsp`
- `src/main/webapp/views/admin/contracts/contractDetail.jsp`
- `src/main/webapp/views/admin/contracts/manageTenants.jsp`
- `src/main/webapp/views/admin/contracts/manageContractTenants.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/contracts.jsp`
- `src/main/webapp/views/customer/contractDetail.jsp`
- `src/main/webapp/views/customer/signContract.jsp`

---

## 6. Billing

**Controllers**
- `src/main/java/Controllers/BillServlet.java`

**DAL**
- `src/main/java/DALs/BillDAO.java`

**Models**
- `src/main/java/Models/Bill.java`
- `src/main/java/Models/BillItem.java`

**Views (Admin)**
- `src/main/webapp/views/admin/bills/bills.jsp`
- `src/main/webapp/views/admin/bills/createBill.jsp`
- `src/main/webapp/views/admin/bills/editBill.jsp`
- `src/main/webapp/views/admin/bills/billDetail.jsp`
- `src/main/webapp/views/admin/bills/billStatus.jsp`
- `src/main/webapp/views/admin/bills/ownerBillList.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/bills.jsp`
- `src/main/webapp/views/customer/billDetail.jsp`

---

## 7. Deposit Management

**Controllers**
- `src/main/java/Controllers/DepositServlet.java`

**DAL**
- `src/main/java/DALs/DepositDAO.java`

**Models**
- `src/main/java/Models/DepositTransaction.java`

**Views (Admin)**
- `src/main/webapp/views/admin/deposits/depositList.jsp`
- `src/main/webapp/views/admin/deposits/depositForm.jsp`

---

## 8. Utility Management

**Controllers**
- `src/main/java/Controllers/UtilityServlet.java`

**DAL**
- `src/main/java/DALs/UtilityDAO.java`

**Models**
- `src/main/java/Models/Utility.java`
- `src/main/java/Models/UtilityPrice.java`
- `src/main/java/Models/UtilityUsage.java`
- `src/main/java/Models/Meter.java`

**Views (Admin)**
- `src/main/webapp/views/admin/utilities/utilities.jsp`
- `src/main/webapp/views/admin/utilities/createUtility.jsp`
- `src/main/webapp/views/admin/utilities/editUtility.jsp`
- `src/main/webapp/views/admin/utilities/utilityDetail.jsp`
- `src/main/webapp/views/admin/utilities/addPrice.jsp`
- `src/main/webapp/views/admin/utilities/editPrice.jsp`
- `src/main/webapp/views/admin/utilities/addUsage.jsp`
- `src/main/webapp/views/admin/utilities/editUsage.jsp`

---

## 9. Price Management

**Controllers**
- `src/main/java/Controllers/PriceServlet.java`

**DAL**
- `src/main/java/DALs/PriceDAO.java`

**Models**
- `src/main/java/Models/PriceCategory.java`
- `src/main/java/Models/PriceHistory.java`

**Views (Admin)**
- `src/main/webapp/views/admin/prices/priceCategories.jsp`
- `src/main/webapp/views/admin/prices/createPriceCategory.jsp`
- `src/main/webapp/views/admin/prices/editPriceCategory.jsp`

---

## 10. Service Management

**Controllers**
- `src/main/java/Controllers/ServiceServlet.java`

**DAL**
- `src/main/java/DALs/ServiceDAO.java`

**Models**
- `src/main/java/Models/Service.java`
- `src/main/java/Models/ServiceUsage.java`

**Views (Admin)**
- `src/main/webapp/views/admin/services/services.jsp`
- `src/main/webapp/views/admin/services/createService.jsp`
- `src/main/webapp/views/admin/services/editService.jsp`
- `src/main/webapp/views/admin/services/serviceDetail.jsp`
- `src/main/webapp/views/admin/services/requestList.jsp`
- `src/main/webapp/views/admin/services/manageRequests.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/services.jsp`
- `src/main/webapp/views/customer/serviceDetail.jsp`
- `src/main/webapp/views/customer/requestService.jsp`
- `src/main/webapp/views/customer/serviceHistory.jsp`

---

## 11. Amenity Management

**Controllers**
- `src/main/java/Controllers/AmenityServlet.java`

**DAL**
- `src/main/java/DALs/AmenityDAO.java`

**Models**
- `src/main/java/Models/Amenity.java`
- `src/main/java/Models/RoomAmenity.java`

**Views (Admin)**
- `src/main/webapp/views/admin/amenities/amenities.jsp`
- `src/main/webapp/views/admin/amenities/createAmenity.jsp`
- `src/main/webapp/views/admin/amenities/editAmenity.jsp`

---

## 12. Facility Management

**Controllers**
- `src/main/java/Controllers/FacilityServlet.java`

**DAL**
- `src/main/java/DALs/FacilityDAO.java`

**Models**
- `src/main/java/Models/Facility.java`
- `src/main/java/Models/RoomFacility.java`

**Views (Admin)**
- `src/main/webapp/views/admin/facilities/facilities.jsp`
- `src/main/webapp/views/admin/facilities/createFacility.jsp`
- `src/main/webapp/views/admin/facilities/editFacility.jsp`
- `src/main/webapp/views/admin/facilities/facilityDetail.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/facilitys.jsp`
- `src/main/webapp/views/customer/facilityDetail.jsp`

---

## 13. Notification

**Controllers**
- `src/main/java/Controllers/NotificationServlet.java`

**DAL**
- `src/main/java/DALs/NotificationDAO.java`

**Models**
- `src/main/java/Models/Notification.java`

**Views (Admin)**
- `src/main/webapp/views/admin/notifications/notifications.jsp`
- `src/main/webapp/views/admin/notifications/createNotification.jsp`
- `src/main/webapp/views/admin/notifications/editNotification.jsp`
- `src/main/webapp/views/admin/notifications/notificationDetail.jsp`

**Views (Customer)**
- `src/main/webapp/views/customer/notifications.jsp`
- `src/main/webapp/views/customer/notificationDetail.jsp`

---

## 14. Activity Log

**Controllers**
- `src/main/java/Controllers/ActivityLogServlet.java`

**DAL**
- `src/main/java/DALs/ActivityLogDAO.java`

**Models**
- `src/main/java/Models/ActivityLog.java`

**Views (Admin)**
- `src/main/webapp/views/admin/activityLog/activityLog.jsp`

---

## 15. Dashboard & Home

**Controllers**
- `src/main/java/Controllers/AdminServlet.java`
- `src/main/java/Controllers/DashboardServlet.java`
- `src/main/java/Controllers/HomeServlet.java`

**Views**
- `src/main/webapp/views/admin/dashboard.jsp`
- `src/main/webapp/views/admin/sidebar.jsp`
- `src/main/webapp/views/guest/home.jsp`
- `src/main/webapp/views/guest/dashboard.jsp`
- `src/main/webapp/views/home.jsp`
- `src/main/webapp/views/navbar.jsp`
- `src/main/webapp/views/footer.jsp`

---

## 16. Shared / Infrastructure

**Utils**
- `src/main/java/Utils/DBContext.java`

**Config**
- `pom.xml`
- `src/main/resources/META-INF/persistence.xml`
- `src/main/webapp/WEB-INF/web.xml`
- `src/main/webapp/WEB-INF/beans.xml`
- `src/main/webapp/META-INF/context.xml`

**Assets**
- `src/main/webapp/assets/css/bootstrap.min.css`
- `src/main/webapp/assets/css/style.css`
- `src/main/webapp/assets/js/bootstrap.bundle.min.js`
- `src/main/webapp/assets/js/main.js`
- `src/main/webapp/assets/js/chatbox.js`
