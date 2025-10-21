export const Button = ({ children, className = '', ...props }) => {
  return (
    <button 
      className={`w-full py-3 px-4 bg-gradient-to-r from-orange-500 to-red-500 
                 hover:from-orange-600 hover:to-red-600 
                 animate-gradient-x
                 text-white font-semibold rounded-lg 
                 transition-all duration-300 
                 shadow-lg hover:shadow-xl 
                 transform hover:scale-105
                 focus:outline-none focus:ring-2 focus:ring-orange-500
                 ${className}`}
      {...props}
    >
      {children}
    </button>
  );
};