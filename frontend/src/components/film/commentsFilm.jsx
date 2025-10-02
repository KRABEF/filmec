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
    </div>
  );
};

const CommentCloud = () => {};

const CommentsList = () => {};

const FeedbackUser = () => {};
