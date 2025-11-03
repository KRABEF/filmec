export const DropDowmMenu = ({ items }) => {
  return (
    <div className="absolute right-0 mt-3 min-w-40 bg-neutral-700 rounded-lg shadow-2xl z-20 select-none">
      <div className="flex flex-col gap-2 m-2">
        {items.map((item, index) => (
          <div
            className="px-4 py-2 text-white hover:bg-orange-600 rounded-md cursor-pointer"
            onClick={item.onClick}
            key={index}
          >
            {item.name}
          </div>
        ))}
      </div>
    </div>
  );
};
