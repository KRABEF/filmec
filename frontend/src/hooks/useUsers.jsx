import { useState } from 'react';
import { userSelect, userId, userDelete } from '../services/userService';

/**
 * Хук для управления пользователями системы
 * Методы: получение всех пользователей, получение по id, удаление пользователей
 */
export const useUsers = () => {
  const [users, setUsers] = useState([]);
  const [selectedUser, setSelectedUser] = useState(null);
  const [loading, setLoading] = useState(false);
  const [error, setError] = useState(null);

  const allUsers = async () => {
    setLoading(true);
    setError(null);

    try {
      const usersData = await userSelect();
      setUsers(usersData);
      return usersData;
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка получения пользователей';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  const getUserId = async (id) => {
    setLoading(true);
    setError(null);

    try {
      const userData = await userId(id);
      setSelectedUser(userData);
      return userData;
    } catch (err) {
      const errMess =
        err.response?.data?.error || err.message || 'Ошибка получения пользователя по id';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  const deleteUser = async (id) => {
    setLoading(true);
    setError(null);

    try {
      await userDelete(id);
      setUsers((prev) => prev.filter((user) => user.id !== id));

      if (selectedUser && selectedUser.id === id) {
        setSelectedUser(null);
      }
    } catch (err) {
      const errMess = err.response?.data?.error || err.message || 'Ошибка удаления пользователя';
      setError(errMess);
      throw errMess;
    } finally {
      setLoading(false);
    }
  };

  return {
    users,
    selectedUser,
    loading,
    error,
    allUsers,
    getUserId,
    deleteUser,
  };
};
