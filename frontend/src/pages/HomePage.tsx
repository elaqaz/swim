import React from 'react';
import { Link } from 'react-router-dom';
import { Button } from '../components/common/Button';

export const HomePage: React.FC = () => {
  return (
    <div className="min-h-screen bg-gradient-to-b from-blue-50 to-white">
      <div className="max-w-7xl mx-auto px-4 sm:px-6 lg:px-8 py-16">
        {/* Hero Section */}
        <div className="text-center mb-16">
          <h1 className="text-5xl font-bold text-gray-900 mb-6">
            Track Your Swimming Performance
          </h1>
          <p className="text-xl text-gray-600 mb-8 max-w-2xl mx-auto">
            Import times, track progress, and check qualification for meets all in one place.
          </p>
          <div className="flex justify-center space-x-4">
            <Link to="/signup">
              <Button size="lg">Get Started</Button>
            </Link>
            <Link to="/login">
              <Button size="lg" variant="secondary">
                Login
              </Button>
            </Link>
          </div>
        </div>

        {/* Features */}
        <div className="grid md:grid-cols-3 gap-8 mt-16">
          <div className="bg-white p-6 rounded-lg shadow-md">
            <div className="text-3xl mb-4">🏊‍♂️</div>
            <h3 className="text-lg font-semibold mb-2">Track Swimmers</h3>
            <p className="text-gray-600">
              Manage multiple swimmers and track their personal bests across all events.
            </p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-md">
            <div className="text-3xl mb-4">📊</div>
            <h3 className="text-lg font-semibold mb-2">Import Times</h3>
            <p className="text-gray-600">
              Automatically import performance data from Swimming England results.
            </p>
          </div>

          <div className="bg-white p-6 rounded-lg shadow-md">
            <div className="text-3xl mb-4">🎯</div>
            <h3 className="text-lg font-semibold mb-2">Check Qualification</h3>
            <p className="text-gray-600">
              Instantly see which meets your swimmers qualify for with smart comparisons.
            </p>
          </div>
        </div>
      </div>
    </div>
  );
};
