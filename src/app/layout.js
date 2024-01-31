import "/node_modules/flag-icons/css/flag-icons.min.css";

export const metadata = {
  title: "ReScript Country Select",
  description: "A ReScript Country Select component for Ahrefs technical test",
};

export default function RootLayout({ children }) {
  return (
    <html lang="en">
      <body
        style={{
          boxSizing: "border-box",
          minHeight: "100vh",
          padding: "100px 0",
          fontFamily: "Arial, system-ui, sans-serif",
          display: "flex",
          justifyContent: "center",
        }}
      >
        {children}
      </body>
    </html>
  );
}
