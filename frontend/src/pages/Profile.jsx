import { useState, useEffect } from 'react';
import { useAuth } from '../hooks/useAuth';
import { Avatar, Button, ButtonSmall, ScrollContainer } from '../components';

export default function Profile() {
  const auth = useAuth();
  const { user } = auth;

  const [formData, setFormData] = useState({ login: '', email: '' });
  const [avatarPreview, setAvatarPreview] = useState(null);
  const [avatarFile, setAvatarFile] = useState(null);

  useEffect(() => {
    if (user) {
      setFormData({
        login: user.login || '',
        email: user.email || '',
      });
      setAvatarPreview(`http://localhost:5075${user.photo}` || null);
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

    try {
      const formDataToSend = new FormData();
      formDataToSend.append('login', formData.login);
      formDataToSend.append('email', formData.email);
      console.log(avatarFile);
      if (avatarFile) formDataToSend.append('photo', avatarFile);

      await auth.update(user.id, formDataToSend);
    } catch (err) {
      console.error('Ошибка обновления:', err);
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
    return <div className="min-h-screen flex items-center justify-center">Загрузка...</div>;
  }

  return (
    <ScrollContainer>
      <div className="max-w-6xl mx-auto p-4 pt-10">
        <div className="grid lg:grid-cols-[auto_1fr] gap-16 items-start">
          <div className="flex flex-col items-center gap-2">
            {avatarPreview ? (
              <Avatar src={`${avatarPreview}`} height="h-52" width="w-52" />
            ) : (
              <div className="w-52 h-52 rounded-full bg-neutral-400/70 flex items-center justify-center text-4xl">
                {user.login?.[0]?.toUpperCase() || '?'}
              </div>
            )}

            <label className="cursor-pointer text-sm text-neutral-400 hover:text-neutral-500">
              Изменить аватар
              <input
                type="file"
                accept="image/*"
                className="hidden"
                onChange={handleAvatarChange}
              />
            </label>

            <div className="text-center mt-6 space-y-1">
              <p className="text-neutral-400 text-sm">Дата регистрации</p>
              <p className="text-lg">
                {user.registration_date
                  ? new Date(user.registration_date).toLocaleDateString('ru-RU', {
                      day: 'numeric',
                      month: 'long',
                      year: 'numeric',
                    })
                  : 'Не указана'}
              </p>
            </div>
          </div>

          {/* Форма */}
          <form onSubmit={handleSubmit} className="w-full max-w-lg space-y-6">
            <div className="form-group">
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

            <div className="lg:flex gap-2">
              <div className="w-[200px] lg:m-0 m-auto">
                <Button type="submit">Сохранить</Button>
              </div>
              <div className="text-center">
                <ButtonSmall
                  type="button"
                  variant="ghost"
                  onClick={handleDeleteAccount}
                  className="text-orange-600 hover:text-orange-700 transition text-sm"
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
