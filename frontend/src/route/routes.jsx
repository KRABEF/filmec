import { Routes, Route, BrowserRouter } from 'react-router-dom';
import App from '../pages/App';
import Profile from '../pages/Profile';
import { Header } from '../components/header';
import { FilmDetailPage } from '../pages/FilmDetailPage';
import { Login } from '../pages/Auth/Login';
import { Register } from '../pages/Auth/Register';
import { EditProfile } from '../pages/Auth/EditProfile';
import { ProtectedRoute } from './protectedRoute';

export const AppRoutes = () => {
  return (
    <BrowserRouter>
      <Header />
      <Routes>
        <Route path="/" element={<App />} />

        <Route path="login" element={<Login />} />
        <Route path="register" element={<Register />} />
        <Route path="movie/:id" element={<FilmDetailPage />} />

        <Route
          path="edit-profile"
          element={
            <ProtectedRoute>
              <EditProfile />
            </ProtectedRoute>
          }
        />
        <Route
          path="profile"
          element={
            <ProtectedRoute>
              <Profile />
            </ProtectedRoute>
          }
        />
      </Routes>
    </BrowserRouter>
  );
};
