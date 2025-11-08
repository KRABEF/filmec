import { useState, useContext, createContext } from 'react';

const TabsContext = createContext(undefined);

export const Tabs = {
  Root: ({ defaultValue, children }) => {
    const [activeValue, setActiveValue] = useState(defaultValue);
    return (
      <TabsContext.Provider value={{ activeValue, setActiveValue }}>
        <div>{children}</div>
      </TabsContext.Provider>
    );
  },

  List: ({ children }) => {
    return <div className="flex gap-2 border-b-1 border-neutral-600">{children}</div>;
  },

  Trigger: ({ value, children }) => {
    const { activeValue, setActiveValue } = useContext(TabsContext);
    const isActive = activeValue === value;

    return (
      <button
        className={`py-2 px-3 cursor-pointer relative ${
          isActive ? 'text-white' : 'text-neutral-400 '
        }`}
        onClick={() => setActiveValue(value)}
      >
        {isActive && (
          <div className="absolute bottom-0 left-0 right-0 h-[2px] bg-orange-500 -mb-[1px] z-10" />
        )}
        <div className="hover:bg-neutral-700 py-1 px-3 rounded-sm">{children}</div>
      </button>
    );
  },

  Content: ({ value, children }) => {
    const context = useContext(TabsContext);
    return context.activeValue === value ? <div>{children}</div> : null;
  },
};
