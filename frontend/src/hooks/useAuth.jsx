import { useState, useEffect } from 'react';
import { userLogin, userCreate, userUpdate, userDelete } from '../services/userService';

/**
 * Хук для управления аутентификацией пользователя
 * Методы: вход, регистрация, обновление, выход
 */
export const authStorage = {
  save(user, token) {
    localStorage.setItem('user', JSON.stringify(user));
    localStorage.setItem('token', token);
  },

  loadUser() {
    const item = localStorage.getItem('user');
    return item ? JSON.parse(item) : null;
  },

  loadToken() {
    return localStorage.getItem('token');
  },

  clear() {
    localStorage.removeItem('user');
    localStorage.removeItem('token');
  },
};

export const useAuth = () => {
  const [user, setUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  useEffect(() => {
    const storedUser = authStorage.loadUser();
    if (storedUser) setUser(storedUser);
  }, []);
  

  const login = async (credentials) => {
    setLoading(true);
    setError(null);
    try {
      const response = await userLogin(credentials);
      authStorage.save(response.user, response.token);
      setUser(response.user);
      return response;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка входа';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  const logout = () => {
    authStorage.clear();
    setUser(null);
    setError(null);
  };

  const register = async (userData) => {
    setLoading(true);
    setError(null);

    try {
      const response = await userCreate(userData);
      authStorage.save(response.user, response.token);
      setUser(response.user);
      return response;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка регистрации';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  const update = async (id, data) => {
    setLoading(true);
    setError(null);
    console.log(data);

    try {
      const response = await userUpdate(id, data);
      authStorage.save(response.user, authStorage.loadToken());
      setUser(response.user);
      // window.location.reload();

      return response;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка обновления пользователя';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  const deleteId = async (id) => {
    setLoading(true);
    setError(null);

    try {
      await userDelete(id);
      logout();
      window.location.href = '/login';
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка удаления пользователя';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  return {
    user,
    loading,
    error,
    login,
    register,
    update,
    logout,
    deleteId,
  };
};
