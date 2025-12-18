import { useState, useEffect } from 'react';
import { useUsers } from '../../hooks/useUsers';
import { useAuthContext } from '../../context/AuthContext';

export const EditProfile = () => {
  const userData = useAuthContext();
  const updateData = useUsers();
  const [formData, setFormData] = useState({
    login: '',
  });

  useEffect(() => {
    if (userData.user) {
      setFormData({
        login: userData.user.login || '',
      });
    }
  }, [userData.user]);

  const handleSubmit = async (e) => {
    e.preventDefault();

    try {
      console.log(formData);
      await userData.update(userData.user.id, formData);
    } catch (err) {
      console.log(err);
    }
  };

  if (!userData.user) {
    return <div>Загрузка</div>;
  }

  return (
    <div className="">
      <h2>Edit Profile</h2>
      <form onSubmit={handleSubmit}>
        <input
          type="text"
          value={formData.login}
          onChange={(e) => setFormData({ ...formData, login: e.target.value })}
          placeholder="login"
        />

        <button type="submit">Сохранить</button>
        {userData.error ||
          (updateData.error && <div className="error">{userData.error || updateData.error}</div>)}
      </form>
    </div>
  );
};
