import { useState } from 'react';
import { BottomNav } from './components/BottomNav';
import { Dashboard } from './components/Dashboard';
import { DietRecord } from './components/DietRecord';
import { Exercise } from './components/Exercise';
import { MyHealth } from './components/MyHealth';

export default function App() {
  const [activeTab, setActiveTab] = useState('dashboard');

  const renderContent = () => {
    switch (activeTab) {
      case 'dashboard':
        return <Dashboard />;
      case 'diet':
        return <DietRecord />;
      case 'exercise':
        return <Exercise />;
      case 'my':
        return <MyHealth />;
      default:
        return <Dashboard />;
    }
  };

  return (
    <div className="size-full bg-background">
      {renderContent()}
      <BottomNav activeTab={activeTab} onTabChange={setActiveTab} />
    </div>
  );
}