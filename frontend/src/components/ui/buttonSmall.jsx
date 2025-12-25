export const ButtonSmall = ({ 
  children, 
  variant = 'solid', 
  className = '', 
  ...props 
}) => {
  const baseStyles = `px-6 py-2 font-semibold rounded-xl transition-all duration-200`;

  const variantStyles =
    variant === 'outline'
      ? ` bg-gradient-to-r from-neutral-800 to-neutral-700/80 text-neutral-100 hover:from-neutral-900 hover:to-neutral-700/90 shadow-lg hover:shadow-xl animate-gradient-x`
      : variant === 'ghost'
      ? `text-neutral-100 hover:text-neutral-200`
      : `bg-neutral-300 text-black hover:bg-neutral-300 shadow-sm hover:shadow-lg animate-gradient-x w-full border border-neutral-300`;
      // : `bg-neutral-300 text-black hover:bg-neutral-300 shadow-sm hover:shadow-lg animate-gradient-x w-full border border-neutral-300`;

  const combinedClassName = `${baseStyles} ${variantStyles} ${className}`;

  return (
    <button {...props} className={combinedClassName.trim()}>
      {children}
    </button>
  );
};