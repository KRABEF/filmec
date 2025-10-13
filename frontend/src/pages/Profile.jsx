import { Tabs } from '../components';

export default function Profile() {
  return (
    <div className="container m-auto">
      <Tabs.Root defaultValue="favorites">
        <Tabs.List>
          <Tabs.Trigger value="favorites">Изранное</Tabs.Trigger>
          <Tabs.Trigger value="later">Смотреть позже</Tabs.Trigger>
        </Tabs.List>

        <div style={{ paddingTop: 12 }}>
          <Tabs.Content value="favorites">
            <p>Тут избранные</p>
          </Tabs.Content>
          <Tabs.Content value="later">
            <p>А тут смотреть позже</p>
          </Tabs.Content>
        </div>
      </Tabs.Root>
    </div>
  );
}
