import { createContext, useContext, useState } from 'react';

const AuthContext = createContext();

export function AuthProvider({ children }) {
  const [user, setUser] = useState(() => {
    const saved = localStorage.getItem('user');

    // if (!saved) {
    //   const fakeUser = {
    //     id: '1',
    //     name: 'Иван Иванов',
    //     email: 'ivan@ivan.com',
    //     avatar: '/ivan.jpg',
    //     role: 'admin',
    //   };
    //   localStorage.setItem('user', JSON.stringify(fakeUser));
    //   return fakeUser;
    // }

    try {
      const saved = localStorage.getItem('user');
      return saved ? JSON.parse(saved) : null;
    } catch {
      return null;
    }
  });

  const login = (userData) => {
    setUser(userData);
    localStorage.setItem('user', JSON.stringify(userData));
  };

  const logout = () => {
    setUser(null);
    localStorage.removeItem('user');
  };

  return <AuthContext.Provider value={{ user, login, logout }}>{children}</AuthContext.Provider>;
}

export function useAuth() {
  const context = useContext(AuthContext);
  if (!context) throw new Error('Error');
  return context;
}
