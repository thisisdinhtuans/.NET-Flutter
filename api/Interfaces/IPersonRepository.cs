using api.Models;

namespace api.Interfaces
{
    public interface IPersonRepository
    {
        ICollection<Person> GetPersons();
        Person GetPerson(int id);
        bool PersonExits(int id);
        bool CreatePerson(Person person);
        bool UpdatePerson(Person person);
        bool DeletePerson(int id);
        bool Save();

    }
}
