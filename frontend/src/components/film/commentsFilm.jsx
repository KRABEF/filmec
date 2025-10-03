import { Avatar } from '../ui/avatar';
import { TextArea } from '../ui/textArea';

export const CommentsFilm = () => {
  return (
    <div className="relative">
      <h3 className="text-2xl font-bold text-white flex items-center gap-2 mb-7">
        Отзывы <span className="bg-orange-600 rounded-full text-sm py-[2px] px-2 ">3</span>
      </h3>
      <div className="flex items-end gap-5">
        <Avatar />
        <TextArea placeholder="Оставьте свои честные комментарии здесь." />
      </div>
      <CommentsList />

    </div>
  );
};

const CommentCloud = () => {
  return (
    <div className="flex items-end gap-2">
      <Avatar />

      <div className="">
        <div className="flex justify-between items-center gap-3 mb-1">
          <p className='text-orange-500'>ivan@email.ru</p>
          <p className='text-sm text-neutral-400'>24.08.2004</p>
        </div>
        <div className="bg-neutral-700 text-neutral-200 px-3 py-2 rounded-lg rounded-bl-none">
          <p>Комментраий</p>
        </div>
      </div>
    </div>
  )
};

const CommentsList = () => {
  return (
    <div className="flex flex-col gap-3">
      <CommentCloud />
      <CommentCloud />
    </div>
  )
};

