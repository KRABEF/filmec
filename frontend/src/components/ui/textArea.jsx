export const TextArea = ({ placeholder }) => {
  return (
    <textarea
      className="py-2 px-3 w-[100%] rounded-lg bg-neutral-700/50"
      rows="3"
      placeholder={placeholder}
    />
  );
};
