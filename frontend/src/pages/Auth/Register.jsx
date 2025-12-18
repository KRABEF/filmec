import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthContext } from '../../context/AuthContext';

export const Register = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    email: '',
    password: '',
    login: '',
  });

  const { loading, error, register } = useAuthContext();

  const handleSubmit = async (e) => {
    e.preventDefault();

    console.log(formData);
    await register(formData);
    navigate('/profile');
  };

  return (
    <div className="">
      <form onSubmit={handleSubmit}>
        <input
          type="email"
          value={formData.email}
          onChange={(e) => setFormData({ ...formData, email: e.target.value })}
          placeholder="email"
        />
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
          Зарегистрироваться
        </button>
        {error && <div className="error">{error}</div>}
      </form>
    </div>
  );
};
