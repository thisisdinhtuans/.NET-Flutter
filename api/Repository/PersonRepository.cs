using api.Data;
using api.Interfaces;
using api.Models;

namespace api.Repository
{
    public class PersonRepository : IPersonRepository
    {
        private readonly DataContext _context;
        public PersonRepository(DataContext context)
        {
            _context= context;
        }
        public bool CreatePerson(Person person)
        {
            _context.Persons.Add(person);
            return Save();
        }

        public bool DeletePerson(int id)
        {
            var person = _context.Persons.FirstOrDefault(p=>p.id==id);
            if (person!=null)
            {
                _context.Persons.Remove(person);
            }
            return Save();
        }

        public Person GetPerson(int id)
        {
            return _context.Persons.Where(p => p.id == id).FirstOrDefault();
        }

        public ICollection<Person> GetPersons()
        {
            return _context.Persons.ToList();
        }

        public bool PersonExits(int id)
        {
            return _context.Persons.Any(c => c.id == id);
        }

        public bool Save()
        {
            var saved=_context.SaveChanges();
            return saved > 0 ? true : false;
        }

        public bool UpdatePerson(Person person)
        {
            _context.Update(person);
            return Save();
        }
    }
}
