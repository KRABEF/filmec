import { useState } from 'react';
import { Avatar } from '../components/ui/avatar';
import { useAuthContext } from '../context/AuthContext';

export default function Profile() {
  const auth = useAuthContext();
  const [formData, setFormData] = useState({});

  if (!auth?.user) {
    return (
      <div className="m-auto container p-7">
        <p>Загрузка...</p>
      </div>
    );
  }
  const handleInputChange = (e) => {
    const { name, value } = e.target;
    setFormData((prev) => ({
      ...prev,
      [name]: value,
    }));
  };
  const { user } = auth;
  return (
    <div className="m-auto container p-7">
      <div className="flex justify-between items-center mb-12">
        <div className="flex items-center">
          <Avatar height="h-30" width="w-30" />
          <div className="ml-4 flex flex-col justify-between h-30">
            {/* <Avatar src={user.photo} /> */}
            <p className="text-lg font-medium">ivan@ivan.com</p>
            <div>
              <p className="text-gray-300">Дата регистрации</p>
              <p className="border-2 mt-1 py-1 px-3 text-lg rounded-lg border-amber-600 w-fit">
                01.01.2023
              </p>
            </div>

            <form action="" className="space-y-3">
              <div className="form-group">
                <label htmlFor="login">Логин</label>
                <input
                  type="text"
                  id="login"
                  name="login"
                  value={user.login || ''}
                  onChange={handleInputChange}
                />
              </div>
              <div className="form-group">
                <label htmlFor="login">Почта</label>
                <input
                  type="text"
                  id="login"
                  name="login"
                  value={user.email || ''}
                  onChange={handleInputChange}
                />
              </div>
            </form>
          </div>
        </div>
      </div>
    </div>
  );
}
