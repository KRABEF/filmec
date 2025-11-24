export const DropDowmMenu = ({ items }) => {
  return (
    <div className="absolute right-0 mt-3 min-w-50 bg-neutral-800/95 rounded-lg shadow-2xl z-20 select-none">
      <div className="flex flex-col gap-2 m-2">
        {items.map((item, index) => (
          <div
            className="px-4 py-2 text-white hover:bg-neutral-700 rounded-md cursor-pointer"
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
