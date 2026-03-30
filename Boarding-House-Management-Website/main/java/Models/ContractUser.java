/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package Models;

import java.time.LocalDate;

/**
 *
 * @author huudanh
 */
public class ContractUser {

    private int contractId;
    private int userId;
    private String role;
    private LocalDate joinedAt;
    private LocalDate leftAt;

    public ContractUser() {
    }

    public ContractUser(int contractId, int userId, String role, LocalDate joinedAt, LocalDate leftAt) {
        this.contractId = contractId;
        this.userId = userId;
        this.role = role;
        this.joinedAt = joinedAt;
        this.leftAt = leftAt;
    }

    public int getContractId() {
        return contractId;
    }

    public void setContractId(int contractId) {
        this.contractId = contractId;
    }

    public int getUserId() {
        return userId;
    }

    public void setUserId(int userId) {
        this.userId = userId;
    }

    public String getRole() {
        return role;
    }

    public void setRole(String role) {
        this.role = role;
    }

    public LocalDate getJoinedAt() {
        return joinedAt;
    }

    public void setJoinedAt(LocalDate joinedAt) {
        this.joinedAt = joinedAt;
    }

    public LocalDate getLeftAt()              { return leftAt; }
    public void setLeftAt(LocalDate leftAt)   { this.leftAt = leftAt; }

    // Denormalized user info (from JOIN)
    private String fullName;
    private String username;
    private String email;
    private String phone;

    public String getFullName()            { return fullName; }
    public void   setFullName(String v)    { this.fullName = v; }
    public String getUsername()            { return username; }
    public void   setUsername(String v)    { this.username = v; }
    public String getEmail()               { return email; }
    public void   setEmail(String v)       { this.email = v; }
    public String getPhone()               { return phone; }
    public void   setPhone(String v)       { this.phone = v; }
}
