export const ScrollContainer = ({ children, className }) => {
  return <div className={`overflow-auto h-[calc(100vh-100px)] ${className}`}>{children}</div>;
};
