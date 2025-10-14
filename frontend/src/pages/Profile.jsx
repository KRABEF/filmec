import { Avatar } from '../components/ui/avatar';

export default function Profile() {
  return (
    <div className="flex justify-between items-center m-auto container p-7">
      <div className="flex justify-between w-full">
        <div className="flex">
          <Avatar height="h-50" width="w-50" />
          <p>Welcome to your profile!</p>Profile
        </div>
        <div>
          <p>Дата регистрации</p>
          <p className="text-center border mt-2 py-1 rounded-lg border-amber-400">01.01.2023</p>
        </div>
      </div>
    </div>
  );
}
