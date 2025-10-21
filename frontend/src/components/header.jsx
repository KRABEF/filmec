import { useState, useRef, useEffect } from 'react';
import { useNavigate } from 'react-router-dom';
import { Avatar } from './ui/avatar';
import { DropDowmMenu } from './ui/dropDowmMenu';
import { ThemeToggle } from './ui/themeSwitch';

export const Header = () => {
  const [isOpen, setIsOpen] = useState(false);
  const menuRef = useRef(null);
  const navigate = useNavigate();

  useEffect(() => {
    const handleClickOutside = (e) => {
      if (menuRef.current && !menuRef.current.contains(e.target)) setIsOpen(false);
    };
    document.addEventListener('mousedown', handleClickOutside);
    return () => document.removeEventListener('mousedown', handleClickOutside);
  }, [setIsOpen]);

  return (
    <div className="p-2 bg-neutral-900 shadow-xl">
      <div className="flex justify-between items-center m-auto container">
        <div onClick={() => navigate('/')}>
          <img className="w-20" src="/logo.svg"></img>
        </div>
        <div className="flex items-center gap-3">
          <ThemeToggle />

          <div className="text-neutral-300 relative" ref={menuRef}>
            <div
              className={`flex gap-2 items-center select-none cursor-pointer`}
              onClick={() => setIsOpen((prev) => !prev)}
            >
              <Avatar width="w-10" height="h-10" />
              <p>ivan@ivan.com</p>
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="10"
                height="10"
                fill="currentColor"
                className={`text-neutral-100 ${isOpen && 'rotate-180'} duration-100`}
                viewBox="0 0 16 16"
              >
                <path
                  fillRule="evenodd"
                  d="M1.646 4.646a.5.5 0 0 1 .708 0L8 10.293l5.646-5.647a.5.5 0 0 1 .708.708l-6 6a.5.5 0 0 1-.708 0l-6-6a.5.5 0 0 1 0-.708"
                />
              </svg>
            </div>
            {isOpen && (
              <DropDowmMenu
                items={[
                  { name: 'Профиль', onClick: () => navigate('/profile') },
                  { name: 'Выйти хачу', onClick: () => alert('Выйти') },
                ]}
              />
            )}
          </div>
        </div>
      </div>
    </div>
  );
};
