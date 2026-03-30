package Controllers;

import DALs.ContractDAO;
import DALs.DepositDAO;
import Models.DepositTransaction;
import Models.User;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.*;

import java.io.IOException;
import java.math.BigDecimal;
import java.util.List;

/**
 * Handles deposit transaction operations for a contract.
 *
 * URL mapping: /deposit
 *
 * GET  /deposit?action=list&contractId=X   → list transactions for a contract
 * GET  /deposit?action=all                 → owner overview of all transactions
 * GET  /deposit?action=form&contractId=X   → show deposit/refund/deduction form
 * POST /deposit?action=record              → insert a deposit_transaction row
 */
public class DepositServlet extends HttpServlet {

    private DepositDAO  depositDAO;
    private ContractDAO contractDAO;

    @Override
    public void init() {
        depositDAO  = new DepositDAO();
        contractDAO = new ContractDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) action = "all";

        switch (action) {
            case "list":  listByContract(request, response); break;
            case "all":   listAll(request, response);        break;
            case "form":  showForm(request, response);       break;
            default:      response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if ("record".equals(action)) {
            recordDeposit(request, response);
        } else {
            response.sendError(HttpServletResponse.SC_NOT_FOUND);
        }
    }

    // ===============================
    // LIST ALL (owner overview)
    // GET /deposit?action=all
    // ===============================
    private void listAll(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        List<DepositTransaction> list = depositDAO.getAll();
        request.setAttribute("deposits", list);
        request.getRequestDispatcher("/views/admin/deposits/depositList.jsp")
               .forward(request, response);
    }

    // ===============================
    // LIST BY CONTRACT
    // GET /deposit?action=list&contractId=X
    // ===============================
    private void listByContract(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        int contractId = Integer.parseInt(request.getParameter("contractId"));
        List<DepositTransaction> list = depositDAO.getByContractId(contractId);
        BigDecimal balance = depositDAO.getBalance(contractId);

        request.setAttribute("deposits", list);
        request.setAttribute("contractId", contractId);
        request.setAttribute("balance", balance);
        request.getRequestDispatcher("/views/admin/deposits/depositList.jsp")
               .forward(request, response);
    }

    // ===============================
    // SHOW DEPOSIT FORM
    // GET /deposit?action=form&contractId=X
    // ===============================
    private void showForm(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String contractIdParam = request.getParameter("contractId");
        if (contractIdParam != null) {
            request.setAttribute("contractId", Integer.parseInt(contractIdParam));
            request.setAttribute("balance", depositDAO.getBalance(Integer.parseInt(contractIdParam)));
        }
        // Pass all contracts for dropdown when no contractId given
        request.setAttribute("contracts", contractDAO.getAll());
        request.getRequestDispatcher("/views/admin/deposits/depositForm.jsp")
               .forward(request, response);
    }

    // ===============================
    // RECORD DEPOSIT / REFUND / DEDUCTION
    // POST /deposit?action=record
    //
    // Params: contractId, amount, transactionType, note
    // ===============================
    private void recordDeposit(HttpServletRequest request, HttpServletResponse response)
            throws IOException {

        try {
            int        contractId = Integer.parseInt(request.getParameter("contractId"));
            BigDecimal amount     = new BigDecimal(request.getParameter("amount"));
            String     type       = request.getParameter("transactionType"); // deposit|refund|deduction
            String     note       = request.getParameter("note");

            // Resolve current logged-in user id
            User currentUser = (User) request.getSession().getAttribute("user");
            int  createdBy   = (currentUser != null) ? currentUser.getUserId() : 0;

            DepositTransaction dt = new DepositTransaction();
            dt.setContractId(contractId);
            dt.setAmount(amount);
            dt.setTransactionType(type);
            dt.setNote(note);
            dt.setCreatedBy(createdBy);

            depositDAO.insert(dt);

        } catch (Exception e) {
            e.printStackTrace();
        }

        // Redirect back to the contract's deposit list
        String contractId = request.getParameter("contractId");
        response.sendRedirect("deposit?action=list&contractId=" + contractId);
    }
}
