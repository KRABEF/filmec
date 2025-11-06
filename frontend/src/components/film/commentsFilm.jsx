import { useState } from 'react';
import { TextArea } from '../ui/textArea';

export const CommentsFilm = () => {
  const [rating, setRating] = useState(0);
  const [comment, setComment] = useState('');

  const handleSubmit = () => {};

  return (
    <div className="relative">
      <div className="mb-7">
        <h3 className="text-2xl font-bold flex items-center gap-2">Твой отзыв на фильм</h3>
        <p className="text-neutral-400 mt-1">
          Здесь пишешь только ты, никто другой не увидит — так что выкладывайся на полную и не
          стесняйся!
        </p>
      </div>

      <div className="flex flex-col">
        <div className="flex items-end gap-4">
          <div className="flex-1">
            <div className="flex justify-between items-center gap-3 mb-2 ">
              <div className="mb-4 flex flex-col w-fit gap-1">
                <div className="flex flex-wrap gap-2">
                  {[1, 2, 3, 4, 5, 6, 7, 8, 9, 10].map((star) => (
                    <button
                      key={star}
                      onClick={() => setRating(star)}
                      className={`flex items-center justify-center text-sm font-semibold ${
                        rating >= star
                          ? 'text-orange-600'
                          : 'dark:text-neutral-500 text-neutral-300 hover:text-orange-600'
                      }`}
                      aria-label={`Оценка ${star} звезд`}
                    >
                      <div className="relative">
                        <svg
                          xmlns="http://www.w3.org/2000/svg"
                          width="45"
                          height="45"
                          fill="currentColor"
                          className="bi bi-star-fill"
                          viewBox="0 0 16 16"
                        >
                          <path d="M3.612 15.443c-.386.198-.824-.149-.746-.592l.83-4.73L.173 6.765c-.329-.314-.158-.888.283-.95l4.898-.696L7.538.792c.197-.39.73-.39.927 0l2.184 4.327 4.898.696c.441.062.612.636.282.95l-3.522 3.356.83 4.73c.078.443-.36.79-.746.592L8 13.187l-4.389 2.256z" />
                        </svg>
                        {rating < star && (
                          <span className="absolute top-1/2 left-1/2 transform -translate-x-1/2 -translate-y-1/2 text-xs font-bold text-neutral-700 ">
                            {star}
                          </span>
                        )}
                      </div>
                    </button>
                  ))}
                </div>

                <div className="lg:flex hidden justify-between text-neutral-600 text-sm">
                  <p>Худшая оценка</p>
                  <p>Лучшая оценка</p>
                </div>
              </div>
              <div className="lg:flex hidden items-center justify-center gap-3 dark:bg-neutral-900/50 bg-neutral-300/50 rounded-xl p-4 w-[80px] h-[80px] shadow-lg">
                <div className="text-center">
                  <div className="text-2xl font-bold text-orange-500">0</div>
                </div>
              </div>
            </div>

            <TextArea
              placeholder="Оставьте свои честные комментарии здесь..."
              value={comment}
              onChange={(e) => setComment(e.target.value)}
              className="min-h-[100px]"
            />
          </div>
        </div>
        <div className="w-fit mt-3 flex gap-2">
          <button
            onClick={handleSubmit}
            className="bg-orange-600 text-neutral-200  py-2 px-4 rounded-lg hover:bg-orange-700 hover:text-white active:scale-95 shadow-lg"
          >
            Сохранить
          </button>
          {true && (
            <button
              onClick={handleSubmit}
              className="dark:bg-neutral-900/60 bg-neutral-300 dark:text-neutral-400 text-neutral-700  py-2 px-4 rounded-lg hover:bg-neutral-900 hover:text-white active:scale-95 shadow-lg"
            >
              Удалить
            </button>
          )}
        </div>
      </div>
    </div>
  );
};
