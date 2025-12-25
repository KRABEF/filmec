import { useState, useEffect } from 'react';
import { Avatar, Button, ButtonSmall, ScrollContainer } from '../components';
import { ErrorAlert } from '../components/ui/errorAlert';
import { useAuthContext } from '../context/AuthContext';

export default function Profile() {
  const auth = useAuthContext();
  const { user } = auth;
  const [error, setError] = useState('');

  const [formData, setFormData] = useState({ login: '', email: '' });
  const [avatarPreview, setAvatarPreview] = useState(null);
  const [avatarFile, setAvatarFile] = useState(null);

  useEffect(() => {
    if (user) {
      setFormData({
        login: user.login || '',
        email: user.email || '',
      });
      setAvatarPreview(user.photo ? `http://localhost:5075${user.photo}` : null);
    }
  }, [user]);

  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({ ...prev, [name]: value }));
  };

  const handleAvatarChange = (e) => {
    const file = e.target.files[0];
    if (file) {
      setAvatarFile(file);
      setAvatarPreview(URL.createObjectURL(file));
    }
  };

  const handleSubmit = async (e) => {
    e.preventDefault();
    setError('');

    try {
      const formDataToSend = new FormData();
      formDataToSend.append('login', formData.login);
      formDataToSend.append('email', formData.email);
      if (avatarFile) formDataToSend.append('photo', avatarFile);

      await auth.update(user.id, formDataToSend);
    } catch (err) {
      const backendError =
        err ||
        err.response?.data?.error ||
        err.response?.data?.message ||
        err.message ||
        err.response?.data?.error ||
        'Не удалось сохранить изменения';
      setError(backendError);
    }
  };

  const handleDeleteAccount = async () => {
    if (confirm('Удалить аккаунт навсегда?')) {
      try {
        await auth.deleteId(user.id);
      } catch (err) {
        console.error('Ошибка:', err);
      }
    }
  };

  if (auth.loading || !user) {
    return (
      <div className="min-h-screen flex items-center justify-center">
        <div className="w-10 h-10 border-4 border-orange-500 border-t-transparent rounded-full animate-spin" />
      </div>
    );
  }

  return (
    <ScrollContainer>
      <div className="max-w-6xl mx-auto p-4 pt-10 space-y-10">
        {/* <div className="max-w-xl space-y-4">
          <h1 className="font-bold text-2xl">Ваш профиль</h1>
          <p className="text-sm">
            Настройте параметры вашего профиля. Вы можете обновить фотографию аватара, логин и адрес
            электронной почты. Нажмите "Сохранить" для применения изменений.
          </p>
        </div> */}

        <div className="grid md:grid-cols-[auto_1fr] gap-16 items-start">
          <div className="flex flex-col items-center gap-6">
            <div className="relative group">
              {avatarPreview ? (
                <Avatar src={avatarPreview} height="h-56" width="w-56" />
              ) : (
                <div className="w-56 h-56 rounded-full bg-neutral-400/70 flex items-center justify-center text-5xl">
                  {user.login?.[0]?.toUpperCase() || '?'}
                </div>
              )}

              <label className="absolute inset-0 bg-black/40 opacity-0 group-hover:opacity-100 transition flex items-center justify-center rounded-full cursor-pointer">
                <span className="text-white text-sm">Сменить фото</span>
                <input
                  type="file"
                  accept="image/*"
                  className="hidden"
                  onChange={handleAvatarChange}
                />
              </label>
            </div>

            <div className="text-center space-y-1">
              <p className="text-neutral-400 text-sm">Дата регистрации</p>
              <p className="text-base">
                {new Date(user.registration_date).toLocaleDateString('ru-RU', {
                  day: 'numeric',
                  month: 'long',
                  year: 'numeric',
                })}
              </p>
            </div>
          </div>

          {/* Форма */}
          <form
            onSubmit={handleSubmit}
            className=" w-full max-w-lg space-y-6"
            // className=" w-full max-w-lg space-y-6 bg-white dark:bg-neutral-700/50 p-7 rounded-xl shadow-xl"
          >
            <ErrorAlert message={error} onClose={() => setError('')} />
            <div className="form-group ">
              <label htmlFor="login">Логин</label>
              <input
                type="text"
                id="login"
                name="login"
                value={formData.login}
                onChange={handleInputChange}
                className={`w-full p-3 border rounded-lg border-orange-500`}
              />
            </div>

            <div className="form-group">
              <label htmlFor="email">Почта</label>
              <input
                type="email"
                id="email"
                name="email"
                value={formData.email}
                onChange={handleInputChange}
                className={`w-full p-3 border rounded-lg border-orange-500`}
              />
            </div>

            <div className="lg:flex gap-1">
              <div className="w-[200px] lg:m-0 m-auto">
                <ButtonSmall type="submit">Сохранить</ButtonSmall>
              </div>
              <div className="text-center">
                <ButtonSmall
                  type="button"
                  variant="ghost"
                  onClick={handleDeleteAccount}
                  className="text-red-600 hover:text-red-700 transition text-sm"
                >
                  Удалить аккаунт
                </ButtonSmall>
              </div>
            </div>
          </form>
        </div>
      </div>
    </ScrollContainer>
  );
}
