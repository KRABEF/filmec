import { useState } from 'react';
import { useNavigate } from 'react-router-dom';
import { useAuthContext } from '../../context/AuthContext';
import { ErrorAlert } from '../../components/ui/errorAlert';
import { Button } from '../../components/ui/button';

export const Register = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    login: '',
    email: '',
    password: '',
  });
  const { loading, error, register } = useAuthContext();

  const handleSubmit = async (e) => {
    e.preventDefault();
    await register(formData);
    navigate('/profile');
  };

  return (
    <div className="min-h-[85vh] flex items-center justify-center px-7">
      <div className="w-full max-w-md bg-white/70 dark:bg-neutral-900/60
                      border border-neutral-200/60 dark:border-neutral-900
                      rounded-2xl shadow-lg dark:shadow-neutral-800/40 shadow-neutral-300/40 md:p-10 p-7 space-y-6">
        
        <div className="text-center space-y-4">
          <h1 className="text-3xl font-semibold">Регистрация</h1>
          <p className="text-sm text-neutral-500">Создайте аккаунт для начала работы</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <ErrorAlert message={error} />
          
          <div>
            <input
              type="text"
              value={formData.login}
              onChange={(e) => setFormData({ ...formData, login: e.target.value })}
              placeholder="Логин"
              required
              className="w-full p-3 border border-neutral-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
            />
          </div>

          <div>
            <input
              type="email"
              value={formData.email}
              onChange={(e) => setFormData({ ...formData, email: e.target.value })}
              placeholder="Email"
              required
              className="w-full p-3 border border-neutral-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
            />
          </div>

          <div>
            <input
              type="password"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              placeholder="Пароль"
              required
              className="w-full p-3 border border-neutral-300 rounded-xl focus:outline-none focus:ring-2 focus:ring-orange-500"
            />
          </div>

          <Button type="submit" disabled={loading} className="py-3 w-full">
            {loading ? 'Регистрация...' : 'Зарегистрироваться'}
          </Button>

          <div className="text-center">
            <p>
              Уже есть аккаунт?{' '}
              <a href="/login" className="text-orange-600 hover:underline font-medium">
                Войти!
              </a>
            </p>
          </div>
        </form>
      </div>
    </div>
  );
};
