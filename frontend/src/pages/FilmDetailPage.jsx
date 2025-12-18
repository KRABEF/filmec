import { ScrollContainer, ActorCarousel, FilmCard, CommentsFilm } from '../components';

export const FilmDetailPage = () => {
  const film = {
    id: 1,
    name: 'Колбаса',
    release_date: '2025',
    genres: ['комедия', 'ужастик'],
    duration_movie: '120 мин',
    rating: 5.3,
    ageLimit: '18+',
    poster: '/25630addd03346e5b2fccdeb32bf.jpg',
    description:
      'Lorem, ipsum dolor sit amet consectetur adipisicing elit. Doloremque, dolores repellendus sit ex doloribus, obcaecati sint eligendi, dolorum beatae laborum quaerat et accusamus laboriosam voluptas aperiam! Debitis praesentium nesciunt et quam, voluptatibus sunt voluptas mollitia nostrum harum eaque amet obcaecati fugiat dignissimos ut, voluptates quo ipsa adipisci sapiente veniam, saepe dolore! Maxime ex beatae quibusdam commodi numquam, cupiditate, nisi excepturi temporibus autem illum quis quos in impedit consequatur? Ex eveniet voluptas id illo veritatis, qui doloremque facere minima libero accusantium quaerat omnis quis itaque. Obcaecati, officiis itaque? Quisquam qui deleniti blanditiis dicta tempora vero, libero natus dolore corrupti. Assumenda excepturi labore molestiae aperiam expedita aliquam quis inventore illum nisi quos, blanditiis dolorem ad delectus? Quasi, placeat voluptate inventore dolores animi sint quia, sapiente nesciunt culpa error quo blanditiis a magnam minus mollitia, accusantium cum recusandae laborum sequi molestias suscipit modi neque maiores! Sunt expedita tempore perspiciatis? Aliquam, eum. Iure eaque quod, commodi, laborum doloremque excepturi tenetur saepe dolores deserunt, maxime qui veniam repudiandae nulla distinctio expedita dolore ut consequuntur? Delectus iste consequuntur repudiandae nam esse aliquid laboriosam reiciendis exercitationem quidem dolores, ex velit doloremque voluptate vitae officiis, aspernatur error cumque. Quisquam a, explicabo excepturi exercitationem adipisci error iure in soluta distinctio tempore nesciunt nemo assumenda aperiam illo, at velit minima asperiores quibusdam necessitatibus fugit voluptas hic, repudiandae dicta. Recusandae aut ipsum, dolorum vero inventore aliquid quo facere temporibus. In, quibusdam. Assumenda soluta iure quia animi? Expedita, eaque illum magnam cupiditate tempora maiores quos quibusdam ad laudantium, velit natus facere harum numquam ipsa veritatis sunt. Quidem aliquid iusto quo, excepturi incidunt minima porro eligendi corporis nam nobis inventore tempora vero ex reprehenderit? Numquam soluta dolor culpa aperiam a quo atque quas necessitatibus, fugiat quaerat sit blanditiis temporibus aliquam eos natus eum expedita. Sequi a vel, expedita quo repellat distinctio dolores. Labore doloribus illum sequi, provident, ducimus assumenda molestias recusandae commodi totam necessitatibus minus, hic quia. Voluptas voluptatum minus ipsum aut, asperiores aliquam quisquam in porro dolorem perspiciatis illo, libero beatae debitis omnis dolore quia ipsa perferendis cum iusto? Alias consectetur perferendis ratione a at deserunt rerum accusamus eaque cum sed omnis ea, quod cumque dolor impedit autem sunt ex. Dolore atque numquam, recusandae eveniet error ipsum nisi perferendis voluptatum, tempore adipisci impedit. Odit delectus unde velit in ipsa architecto assumenda, molestiae beatae inventore, cum nobis. Fugit laboriosam eveniet dolor non expedita quo ex deserunt molestiae. Aliquid consequuntur, necessitatibus a hic officia quod iure deleniti earum molestiae aspernatur? Saepe dolorum soluta recusandae mollitia beatae provident neque odio animi repudiandae! Repellat, repellendus. Animi, similique quam recusandae eveniet repudiandae, velit soluta aperiam accusantium iste obcaecati ipsum repellat commodi dolores est voluptatem deserunt impedit autem repellendus illo. Sit qui, praesentium ducimus harum rerum adipisci alias numquam ratione aspernatur placeat. Autem nulla, est commodi architecto voluptates enim ipsam, iure, facilis asperiores deserunt consectetur eveniet numquam? Ad, praesentium, iusto similique hic impedit aperiam molestias ratione inventore, laudantium animi ab repudiandae non voluptatum! Blanditiis cum corporis libero ullam, ipsam ipsa error. Deserunt rerum recusandae harum similique doloribus mollitia!',
  };

  const actors = [
    { id: 1, name: 'Дмитрий Нагиев', isDirector: true },
    { id: 2, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 3, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 4, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 5, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиева' },
    { id: 6, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 7, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 8, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 9, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 10, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
    { id: 11, photo: '/actors/16664958.jpg', name: 'Дмитрий Нагиев' },
  ];

  return (
    <ScrollContainer>
      <div className="max-w-6xl mx-auto py-6 space-y-20 px-4">
        <FilmCard film={film} />
        <ActorCarousel actors={actors} />
        <CommentsFilm />
      </div>
    </ScrollContainer>
  );
};
