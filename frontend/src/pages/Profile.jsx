import { useState } from 'react';
import { Avatar } from '../components/ui/avatar';
import { Button } from '../components/ui/button';

export default function Profile() {
  const [activeTab, setActiveTab] = useState('favorites');

  return (
    <div className="m-auto container p-7">
      <div className="flex justify-between items-center mb-12">
        <div className="flex items-center">
          <Avatar height="h-30" width="w-30" />
          <div className="ml-4 flex flex-col justify-between h-30">
            <p className="text-lg font-medium">ivan@ivan.com</p>
            <div>
              <p className="text-gray-300">Дата регистрации</p>
              <p className="border-2 mt-1 py-1 px-3 text-lg rounded-lg border-amber-600 w-fit">
                01.01.2023
              </p>
            </div>
          </div>
          <div className="ml-12">
            <Button variant="primary" size="lg" className="flex items-center gap-2">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="20"
                height="20"
                fill="currentColor"
                className="bi bi-download"
                viewBox="0 0 16 16"
              >
                <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5" />
                <path d="M7.646 11.854a.5.5 0 0 0 .708 0l3-3a.5.5 0 0 0-.708-.708L8.5 10.293V1.5a.5.5 0 0 0-1 0v8.793L5.354 8.146a.5.5 0 1 0-.708.708z" />
              </svg>
              Скачать грамоту
            </Button>
          </div>
          <div className="ml-12">
            <Button variant="primary" size="lg" className="flex items-center gap-2">
              <svg
                xmlns="http://www.w3.org/2000/svg"
                width="16"
                height="16"
                fill="currentColor"
                class="bi bi-upload"
                viewBox="0 0 16 16"
              >
                <path d="M.5 9.9a.5.5 0 0 1 .5.5v2.5a1 1 0 0 0 1 1h12a1 1 0 0 0 1-1v-2.5a.5.5 0 0 1 1 0v2.5a2 2 0 0 1-2 2H2a2 2 0 0 1-2-2v-2.5a.5.5 0 0 1 .5-.5" />
                <path d="M7.646 1.146a.5.5 0 0 1 .708 0l3 3a.5.5 0 0 1-.708.708L8.5 2.707V11.5a.5.5 0 0 1-1 0V2.707L5.354 4.854a.5.5 0 1 1-.708-.708z" />
              </svg>
              Импортировать медиатеку{' '}
            </Button>
          </div>
        </div>
      </div>

      <div className="flex flex-col items-center">
        <h1 className="text-3xl font-bold mb-8">Фильмотека</h1>

        <div className="flex gap-8 mb-8">
          <button
            onClick={() => setActiveTab('favorites')}
            className={`pb-2 text-lg font-medium relative ${
              activeTab === 'favorites'
                ? 'text-amber-600 after:absolute after:left-0 after:bottom-0 after:h-[2px] after:w-full after:bg-amber-600'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            Избранное
          </button>

          <button
            onClick={() => setActiveTab('watchLater')}
            className={`pb-2 text-lg font-medium relative ${
              activeTab === 'watchLater'
                ? 'text-amber-600 after:absolute after:left-0 after:bottom-0 after:h-[2px] after:w-full after:bg-amber-600'
                : 'text-gray-500 hover:text-gray-700'
            }`}
          >
            Смотреть позже
          </button>
        </div>

        {activeTab === 'favorites' && (
          <p className="text-gray-500 mt-4">Здесь будут фильмы из избранного</p>
        )}
        {activeTab === 'watchLater' && (
          <p className="text-gray-500 mt-4">Здесь будут фильмы "смотреть позже"</p>
        )}
      </div>
    </div>
  );
}
