import { useState } from 'react';
import { useAuthContext } from '../../context/AuthContext';
import { useNavigate } from 'react-router-dom';
import { Button } from '../../components/ui/button';
import { ErrorAlert } from '../../components/ui/errorAlert';

export const Login = () => {
  const navigate = useNavigate();
  const [formData, setFormData] = useState({
    login: '',
    password: '',
  });

  const { login, loading, error } = useAuthContext();

  const handleSubmit = async (e) => {
    e.preventDefault();
    await login(formData);
    navigate('/profile');
  };

  return (
    <div className="min-h-[85vh] flex items-center justify-center px-7">
      <div
        className="w-full max-w-md bg-white/70 dark:bg-neutral-900/60
                      border border-neutral-200/60 dark:border-neutral-900
                      rounded-2xl shadow-lg dark:shadow-neutral-800/40 shadow-neutral-300/40 md:p-10 p-7 space-y-6"
      >
        <div className="text-center space-y-4">
          <h1 className="text-3xl font-semibold">Вход</h1>
          <p className="text-sm text-neutral-500">Войдите в аккаунт, чтобы продолжить</p>
        </div>

        <form onSubmit={handleSubmit} className="space-y-4">
          <ErrorAlert message={error} />
          <div>
            <input
              type="text"
              value={formData.login}
              onChange={(e) => setFormData({ ...formData, login: e.target.value })}
              placeholder="Введите логин"
              required
            />
          </div>

          <div>
            <input
              type="password"
              value={formData.password}
              onChange={(e) => setFormData({ ...formData, password: e.target.value })}
              placeholder="Введите пароль"
              required
            />
          </div>

          <Button type="submit" disabled={loading} className="py-3">
            {loading ? 'Вход...' : 'Войти'}
          </Button>
          <div className="text-center">
            <p>
              Нет аккаунт?{' '}
              <a href="/register" className="text-orange-600 hover:underline font-medium">
                Зарегистрироваться!
              </a>
            </p>
          </div>
        </form>
      </div>
    </div>
  );
};
