module.exports = {
  plugins: [
    require("@tailwindcss/custom-forms"),
  ],
  variants: {
    cursor: ["responsive", "disabled"],
    opacity: ["responsive", "hover", "focus", "disabled"],
  },
}
