import type { Config } from "tailwindcss";

export default {
  content: ["./app/**/*.{ts,tsx}", "./components/**/*.{ts,tsx}"],
  theme: {
    extend: {
      colors: {
        ink: "#112b25",
        forest: "#115e4c",
        leaf: "#1f8068",
        mint: "#eaf5f0",
        cream: "#f7f7f2",
        sun: "#f2b94b"
      },
      boxShadow: {
        card: "0 1px 2px rgba(17,43,37,.05), 0 10px 30px rgba(17,43,37,.06)"
      },
      fontFamily: { sans: ["Inter", "ui-sans-serif", "system-ui", "Segoe UI", "Arial", "sans-serif"] }
    }
  },
  plugins: []
} satisfies Config;
