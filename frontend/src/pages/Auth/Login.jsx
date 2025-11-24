import { useState } from 'react';
import { useAuthContext } from '../../context/AuthContext';

export const Login = () => {
  const [formData, setFormData] = useState({
    password: '',
    login: '',
  });

  const { login, loading, error } = useAuthContext();

  const handleSubmit = async (e) => {
    e.preventDefault();

    await login(formData);
  };

  return (
    <div className="">
      <form onSubmit={handleSubmit}>
        <input
          type="login"
          value={formData.login}
          onChange={(e) => setFormData({ ...formData, login: e.target.value })}
          placeholder="login"
        />
        <input
          type="password"
          placeholder="password"
          value={formData.password}
          onChange={(e) => setFormData({ ...formData, password: e.target.value })}
        />
        <button type="submit" disabled={loading}>
          Войти
        </button>
        {error && <div className="error">{error}</div>}
      </form>
    </div>
  );
};
