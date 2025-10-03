export const TextArea = ({ placeholder }) => {
  return (
    <textarea
      className="py-2 px-3 w-[100%] rounded-lg bg-neutral-900/50 border-0 focus:border-0"
      rows="8"
      placeholder={placeholder}
    />
  );
};
