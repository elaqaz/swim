import React from 'react';
import { LoginForm } from '../components/auth/LoginForm';
import { Card } from '../components/common/Card';

export const LoginPage: React.FC = () => {
  return (
    <div className="min-h-screen bg-gray-50 flex items-center justify-center px-4">
      <div className="w-full max-w-md">
        <div className="text-center mb-8">
          <h1 className="text-3xl font-bold text-gray-900">Swim</h1>
          <p className="mt-2 text-gray-600">Track your swimming performance</p>
        </div>

        <Card>
          <h2 className="text-2xl font-bold text-gray-900 mb-6">Login</h2>
          <LoginForm />
        </Card>
      </div>
    </div>
  );
};
