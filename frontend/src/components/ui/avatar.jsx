export const Avatar = ({ height = 'h-10', width = 'w-10', src }) => {
  return (
    <div
      className={`rounded-full overflow-hidden flex-shrink-0 ${width} ${height} flex items-center justify-center`}
    >
      <img src={src} className="w-full h-full object-cover" alt="Avatar" />
    </div>
  );
};
