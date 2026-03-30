package Utils;

import java.time.Instant;
import java.util.Map;
import java.util.Random;
import java.util.concurrent.ConcurrentHashMap;

/**
 * In-memory store for email OTP verification.
 * Each OTP expires after OTP_TTL_SECONDS.
 * Thread-safe via ConcurrentHashMap + singleton.
 */
public class OtpStore {

    private static final int OTP_TTL_SECONDS = 300; // 5 minutes
    private static final OtpStore INSTANCE = new OtpStore();

    private final Map<String, OtpEntry> store = new ConcurrentHashMap<>();
    private final Random random = new Random();

    private OtpStore() {}

    public static OtpStore getInstance() {
        return INSTANCE;
    }

    /**
     * Generate a 6-digit OTP for the given email.
     * Overwrites any existing OTP for that email.
     */
    public String generate(String email) {
        String otp = String.format("%06d", random.nextInt(1_000_000));
        store.put(email.toLowerCase(), new OtpEntry(otp, Instant.now().plusSeconds(OTP_TTL_SECONDS)));
        return otp;
    }

    /**
     * Verify OTP for the given email.
     * Returns true if OTP matches and has not expired.
     * Does NOT consume the OTP — call remove() explicitly after success.
     */
    public boolean verify(String email, String otp) {
        OtpEntry entry = store.get(email.toLowerCase());
        if (entry == null) return false;
        if (Instant.now().isAfter(entry.expiry)) {
            store.remove(email.toLowerCase());
            return false;
        }
        return entry.otp.equals(otp);
    }

    /** Remove OTP after successful use or manual cleanup. */
    public void remove(String email) {
        store.remove(email.toLowerCase());
    }

    // ---- inner record ----
    private static class OtpEntry {
        final String otp;
        final Instant expiry;

        OtpEntry(String otp, Instant expiry) {
            this.otp = otp;
            this.expiry = expiry;
        }
    }
}
